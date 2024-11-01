# frozen_string_literal: true

class Post < ApplicationRecord
  include AASM

  belongs_to :creator, class_name: 'User'
  belongs_to :region

  validates :title, :body, presence: true
  validates :body, length: { minimum: 50 }
  validates :files, size: { less_than: 5.megabytes }
  validates :images, size: { less_than: 5.megabytes }, content_type: %i[png jpg jpeg]

  has_many_attached :files
  has_many_attached :images

  aasm column: :state do
    state :draft, initial: true
    state :under_moderation, :published, :rejected

    event :moderate do
      transitions from: :draft, to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end
  end
end
