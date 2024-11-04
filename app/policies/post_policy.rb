# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  authorize :user, allow_nil: true

  scope_for :index do |relation|
    return relation.where(state: :under_moderation) if user&.admin?
    return relation.where(creator_id: user.id) if user&.author?

    relation
  end

  def create?
    user.present?
  end

  def show?
    return record.under_moderation? if user&.admin?

    true
  end

  def export?
    true
  end

  def publish?
    user.admin?
  end

  def reject?
    user.admin?
  end

  def moderate?
    user.author? && record.draft? && record.creator_id == user.id
  end

  def destroy?
    user.author? && record.draft? && record.creator_id == user.id
  end
end
