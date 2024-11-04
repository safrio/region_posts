# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, inverse_of: :creator, dependent: :destroy, foreign_key: :creator_id
  belongs_to :region, optional: true

  validates :full_name, :type, presence: true
  validates :region, presence: true, if: -> () { type == 'Author' }

  def admin?
    type == 'Admin'
  end

  def author?
    type == 'Author'
  end

  def to_s
    full_name
  end
end
