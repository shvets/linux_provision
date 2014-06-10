ActiveRecord::Base.establish_connection(
    :adapter  => 'postgresql',
    :host     => 'localhost',
    :username => 'ruby_dev',
    :password => 'ruby_dev',
    :database => 'ruby_dev_dev',
    :port     => "5432",
    :encoding => 'utf8'
)
