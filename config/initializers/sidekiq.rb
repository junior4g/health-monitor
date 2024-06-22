require 'sidekiq'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://172.17.0.2:6379/0' }

  config.on(:startup) do
    schedule_file = "config/schedule.yml"

    if File.exist?(schedule_file) && Sidekiq.server?
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://172.17.0.2:6379/0' }
end
