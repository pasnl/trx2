json.array!(@activities) do |transaction|
  json.extract! transaction, :id, :voucher_id, :user_id, :tr_date, :tr_type
  json.url transaction_url(transaction, format: :json)
end
