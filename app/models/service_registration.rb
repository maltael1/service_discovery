class ServiceRegistration < ApplicationRecord
  belongs_to :service
  
  validates :host, :gate_host, :service_id, :token, presence: true
  validates :token, uniqueness: true
  validates :host, :gate_host, uniqueness_confirmed: true
  validates :host, :gate_host, http_url: true

  enum status: [ :registred, :confirmed, :lost ]

  scope :confirmed, -> { where(status: ServiceRegistration.statuses[:confirmed]) }

  def init_token
    self.token = Digest::MD5.hexdigest(Time.zone.now.to_s)
  end

end
