json.extract! customer, :id, :first_name, :last_name, :email, :created_at, :updated_at
json.url user_url(customer, format: :json)
