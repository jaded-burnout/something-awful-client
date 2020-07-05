RSpec.configure do |config|
  config.around(:example, time_sensitive: true) do |example|
    Timecop.freeze do
      example.run
    end
  end
end
