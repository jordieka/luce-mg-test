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
#  xero_line_item_id :string
#
# Indexes
#
#  index_transactions_on_invoice_id  (invoice_id)
#
# Foreign Keys
#
#  invoice_id  (invoice_id => invoices.id)
#
require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
