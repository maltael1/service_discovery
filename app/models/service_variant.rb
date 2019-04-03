class ServiceVariant < ApplicationRecord
    has_many :services
    before_save :init_token

    private
    
    def init_token
        self.token = Digest::MD5.hexdigest(Time.zone.now.to_s)
    end
    
end
