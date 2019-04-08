class ServiceVariant < ApplicationRecord

    has_many :services
    has_many :logs, as: :reference

    before_save :init_token, if: Proc.new { |service_variant| service_variant.token.nil? }

    private
    
    def init_token
        self.token = Digest::MD5.hexdigest(Time.zone.now.to_s)
    end
    
end
