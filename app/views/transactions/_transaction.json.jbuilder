json.extract! transaction, :id, :unit_amount, :quantity, :date, :description, :invoice_id, :created_at, :updated_at
json.url client_invoice_transaction_url(id: transaction.id, format: :json)
