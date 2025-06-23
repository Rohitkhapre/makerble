Rails.application.config.after_initialize do
  ActiveRecord::Base.verbose_query_logs = true
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  
  puts "Database Configuration:"
  puts ActiveRecord::Base.connection_config.inspect
rescue => e
  puts "Failed to connect to database: #{e.message}"
  puts e.backtrace
end
