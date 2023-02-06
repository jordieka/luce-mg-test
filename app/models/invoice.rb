# == Schema Information
#
# Table name: invoices
#
#  id              :integer          not null, primary key
#  amount          :float
#  due_date        :date
#  issue_date      :date
#  paid_amount     :float
#  payment_status  :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  client_id       :integer          not null
#  xero_invoice_id :string           # new field to store xero InvoiceID 
#
# Indexes
#
#  index_invoices_on_client_id  (client_id)
#
# Foreign Keys
#
#  client_id  (client_id => clients.id)
#

class Invoice < ApplicationRecord

  # we can use gem state_machine to update status and payment status so it can store the history of status fro and status to and date of the changed date 
  STATUSES = %w[NEW CONFIRMED CANCELLED].freeze
  PAYMENT_STATUSES = %w[PAID UNPAID UNDERPAID].freeze

  XERO_PAYMENT_STATUSES = {
    "NEW" => "DRAFT",
    "CONFIRMED" => "SUBMITTED",
    "CANCELLED" => "VOIDED"
  }.freeze

  belongs_to :client
  has_many :transactions, dependent: :destroy

  validates :status, presence: true, inclusion: STATUSES
  validates :payment_status, presence: true, inclusion: PAYMENT_STATUSES

  after_create :save_to_xero
  after_update :update_invoice_xero

  scope :by_client_id, ->(client_id) { where(client_id: client_id) }

  def cancel
    update_attributes(status: 'CANCELLED')
  end

  def confirm
    update_attributes(status: 'CONFIRMED')
  end

  def update_amount
    update_attributes(amount: compute_amount)
  end

  def compute_amount
    transactions.sum(&:amount)
  end

  def save_to_xero
    # this is a method to create xero invoice after the invoice created
    # for further development I think we can move this to a job / delayed job
    # it can be in every invoice or maybe after sometimes we can run the job that contains a few invoices data

    invoice_service = Xero::InvoiceServices.new
    request = invoice_service.create_invoice(self)

    if request[:meta][:code].eql?(200)
      response = request[:data]["Invoices"][0]

      self.update(xero_invoice_id: response["InvoiceID"]) if xero_invoice_id.blank?
      
      self.transactions.order(id: :asc).each_with_index do |trans, index|
        trans.update(xero_line_item_id: response["LineItems"][index]["LineItemID"]) if trans.xero_line_item_id.blank?
      end
    end
  end

  def update_invoice_xero
    # this is a method to update xero invoice data after the invoice being updated
    # for example, after save a transaction there will be a callback to hit the invoice update_amount
    # the update_amount method will also call this method 

    invoice_service = Xero::InvoiceServices.new
    request = invoice_service.update_invoice(self)

    request[:meta][:code].eql?(200)
  end
end
