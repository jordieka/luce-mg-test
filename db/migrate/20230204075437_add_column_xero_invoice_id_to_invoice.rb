class AddColumnXeroInvoiceIdToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :xero_invoice_id, :string
  end
end
