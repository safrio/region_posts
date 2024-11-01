# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action do
    ActiveStorage::Current.url_options = { host: 'http://localhost:3000' } if Rails.env.development? || Rails.env.test?
  end

  rescue_from ActionPolicy::Unauthorized do |ex|
    flash.now[:danger] = if ex.result.reasons.details.empty?
      I18n.t('flashes.session.non_authorized')
    else
      reason = ex.result.reasons.details&.values&.flatten&.first
      I18n.t(reason.presence, scope: 'flashes.session', default: I18n.t('flashes.session.non_authorized'))
    end

    respond_to do |format|
      format.html { safe_redirect_back fallback_location: root_path, danger: flash.now[:danger], status: :see_other }
      format.turbo_stream { render turbo_stream: [turbo_stream.replace('flashes', partial: 'partials/flashes')] }
    end
  end

  # prevent infinity redirection loop
  def safe_redirect_back(**args)
    if URI(request.referer.to_s).path == URI(request.url).path
      redirect_to args.fetch(:fallback_location, root_path), **args
    else
      redirect_back(**args)
    end
  end

  def authenticate_admin!
    raise ActionPolicy::Unauthorized unless current_user && current_user.try(:admin?)
  end
end
