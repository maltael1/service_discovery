json.extract! service_registration, :id, :service_id, :status_cd, :host, :code, :created_at, :updated_at. :token
json.url service_registration_url(service_registration, format: :json)
