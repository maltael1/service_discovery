class Service < ApplicationRecord
    has_many :service_registrations
    before_save :init_token

    def register_service(host: nil, gate_host: nil)

        @service = service_registrations.where(
            host: host,
            gate_host: gate_host, 
        ).where.not(status: ServiceRegistration.statuses[:confirmed]).first
        @service = service_registrations.build if @service.nil?

        @service.host = host
        @service.gate_host = gate_host
        @service.status = ServiceRegistration.statuses[:registred]
        @service.init_token
        @service
    end

    private
    
    def init_token
        self.token = Digest::MD5.hexdigest(Time.zone.now.to_s)
    end
end
