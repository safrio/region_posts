class RegionPolicy < ApplicationPolicy
  scope_for :form_select do |relation|
    return relation if user.type == 'Admin'

    return relation.where(id: user.region_id) if user.type == 'Author'
  end
end
