# == Schema Information
#
# Table name: transactions
#
#  id                :integer          not null, primary key
#  date              :date
#  description       :string
#  quantity          :integer
#  unit_amount       :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  invoice_id        :integer          not null
#  xero_line_item_id :string           # new field to store xero LineItemID
#
# Indexes
#
#  index_transactions_on_invoice_id  (invoice_id)
#
# Foreign Keys
#
#  invoice_id  (invoice_id => invoices.id)
#

class Transaction < ApplicationRecord
  belongs_to :invoice

  scope :by_invoice_id, ->(invoice_id) { where(invoice_id: invoice_id) }

  after_save :update_amount_invoice

  def amount
    unit_amount * quantity
  end

  def update_amount_invoice
    invoice.update_amount
  end
end
