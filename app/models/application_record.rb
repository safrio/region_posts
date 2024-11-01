class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ransackable_attributes(auth_object = nil)
    super
  end

  def self.ransackable_associations(auth_object = nil)
    super
  end
end
