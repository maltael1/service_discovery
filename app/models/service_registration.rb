class Service < ApplicationRecord
  belongs_to :service_variant
  
  validates :host, :gate_host, :service_id, :token, presence: true
  validates :token, uniqueness: true
  validates :host, :gate_host, uniqueness_confirmed: true
  validates :host, :gate_host, http_url: true

  enum status: [ :registred, :confirmed, :lost ]

  scope :confirmed, -> { where(status: Service.statuses[:confirmed]) }
  scope :innvative, -> { where.not(status: Service.statuses[:confirmed]) }
  scope :active, -> {confirmed.group(:service_variant_id)}
  def init_token
    self.token = Digest::MD5.hexdigest(Time.zone.now.to_s)
  end

  def self.hosts_by_code
    json = {}
    active.each do |service|
        json[service.service_variant.code] = service.host
    end
    json
end

end
