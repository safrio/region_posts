# frozen_string_literal: true

class Admin < User
  def self.polymorphic_name
    'Admin'
  end
end
