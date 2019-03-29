class UniquenessConfirmedValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.present? && ServiceRegistration.where("#{attribute} = '#{value}'").where(status: ServiceRegistration.statuses[:confirmed]).first.nil?
      record.errors.add(attribute, "service already confirmed")
    end
  end

end