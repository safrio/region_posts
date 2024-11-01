# frozen_string_literal: true

class Region < ApplicationRecord
  validates :name, presence: true

  has_many :posts, dependent: :destroy

  def to_s
    name
  end
end
