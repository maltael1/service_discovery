class Service < ApplicationRecord
    has_many :service_registrations
    before_save :init_token

    private
    
    def init_token
        self.token = Digest::MD5.hexdigest(Time.zone.now.to_s)
    end
    
end
