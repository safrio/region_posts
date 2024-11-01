# frozen_string_literal: true

module ApplicationHelper
  def nav_menu_item(name, path = '#', options = {})
    assembled_options = options.merge(class: "nav-link link-dark #{active?(path)}")
    tag.li class: 'nav-item' do
      link_to path, assembled_options do
        tag.div(name)
      end
    end
  end

  def active?(path, options = {})
    if options.key? :active_if
      'active' if options[:active_if]
    elsif current_page?(path)
      'active'
    end
  end

  def regions_collection
    return Region.all.pluck(:name, :id) unless current_user.present?

    RegionPolicy.new(user: current_user).apply_scope(Region.all, type: :form_select).pluck(:name, :id)
  end
end
