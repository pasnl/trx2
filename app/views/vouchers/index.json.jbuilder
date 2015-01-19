json.array!(@vouchers) do |voucher|
  json.extract! voucher, :id, :user_id, :cash_date, :cash_value, :content_id
  json.url voucher_url(voucher, format: :json)
end
