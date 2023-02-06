class AddColumnXeroLineItemIdToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :xero_line_item_id, :string
  end
end
