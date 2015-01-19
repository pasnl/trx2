json.array!(@punches) do |punch|
  json.extract! punch, :id, :punch_code, :program_id, :activity_id
  json.url punch_url(punch, format: :json)
end
