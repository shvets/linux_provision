postgresql_host = ENV['POSTGRESQL_HOST'].nil? ? 'localhost' : ENV['POSTGRESQL_HOST']

ActiveRecord::Base.establish_connection(
    :adapter  => 'postgresql',
    :host     => postgresql_host,
    :username => 'ruby_dev',
    :password => 'ruby_dev',
    :database => 'ruby_dev_dev',
    :port     => "5432",
    :encoding => 'utf8'
)
