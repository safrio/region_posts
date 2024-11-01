# frozen_string_literal: true

SIDEKIQ_WILL_PROCESSES_JOBS_FILE = Rails.root.join('tmp/sidekiq_process_has_started_and_will_begin_processing_jobs')

redis =
  if Rails.env.development? || Rails.env.test?
    {
      url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0')
    }
  else
    {
      url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0'),
      password: ENV.fetch('REDIS_PASS', 'redis-pass')
    }
  end

Sidekiq.configure_client do |config|
  config.redis = redis
end

Sidekiq.configure_server do |config|
  config.redis = redis

  config.on(:startup) do
    FileUtils.touch(SIDEKIQ_WILL_PROCESSES_JOBS_FILE)
  end

  config.on(:shutdown) do
    FileUtils.rm_f(SIDEKIQ_WILL_PROCESSES_JOBS_FILE)
  end
end
