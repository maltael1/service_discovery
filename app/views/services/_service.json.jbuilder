json.extract! service, :id, :service_variant_id, :status_cd, :host, :code, :created_at, :updated_at. :token
json.url service_url(service, format: :json)
