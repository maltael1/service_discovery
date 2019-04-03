class ServiceLog < ApplicationRecord
  belongs_to :service

  enum status: [ :ok, :warning, :info, :error ]

end
