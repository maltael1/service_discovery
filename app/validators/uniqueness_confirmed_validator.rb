class UniquenessConfirmedValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.present? && Service.where("#{attribute} = '#{value}'").where(status: Service.statuses[:confirmed]).where.not(id: record.id).first.nil?
      record.errors.add(attribute, "Service already confirmed")
    end
  end

end