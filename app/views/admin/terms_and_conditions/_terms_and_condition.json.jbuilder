json.extract! terms_and_condition, :id, :status, :summary, :full, :created_at, :updated_at
json.url admin_terms_and_condition_url(terms_and_condition, format: :json)
