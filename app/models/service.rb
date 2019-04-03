class Service < ApplicationRecord
  belongs_to :service_variant

  has_many :logs, as: :reference

  validates :host, :gate_host, :service_variant_id, :token, presence: true
  validates :token, uniqueness: true
  validates :host, :gate_host, uniqueness_confirmed: true
  validates :host, :gate_host, http_url: true

  enum status: [ :registred, :confirmed, :lost, :active ]

  scope :confirmed, -> { where(status: Service.statuses[:confirmed]) }
  scope :innactive, -> { where.not(status: Service.statuses[:confirmed]) }
  scope :active, -> { where(status: Service.statuses[:active])}
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
