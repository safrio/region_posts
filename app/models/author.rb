# frozen_string_literal: true

class Author < User
  def self.polymorphic_name
    'Author'
  end
end
