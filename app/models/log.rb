class Log < ApplicationRecord
  belongs_to :reference, polymorphic: true

  enum status: [ :ok, :warning, :info, :error ]

end
