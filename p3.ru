require '.p3.rb'

Rack::Server.start(
	:app => PPP.App.new,
	:Port => 8000,
	:server => 'thin'
 )
