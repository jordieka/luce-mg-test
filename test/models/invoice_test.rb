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
#  xero_invoice_id :string
#
# Indexes
#
#  index_invoices_on_client_id  (client_id)
#
# Foreign Keys
#
#  client_id  (client_id => clients.id)
#
require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
