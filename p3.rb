require 'rack/request'
require 'rack/response'
require 'rack'
require 'haml'
require 'thin'
  
module RockPaperScissors

	class App

		def initialize(app = nil)
			@app = app
			@content_type = :html
			@defeat = {'Piedra' => 'Tijeras', 'Papel' => 'Piedra', 'Tijeras' => 'Papel'}
			@throws = @defeat.keys
			@throws = @defeat.keys
			@choose = @throws.map { |x| %Q{ <li><a href="/?choice=#{x}">#{x}</a></li> } }.join("\n")
			@choose = "<p>\n<ul>\n#{@choose}\n</ul>"

		end

		def call(env)
			req = Rack::Request.new(env)

			req.env.keys.sort.each { |x| puts "#{x} => #{req.env[x]}" }

			computer_throw = @throws.sample
			player_throw = req.GET["choice"]
			anwser = if !@throws.include?(player_throw)
				"Elige:"
				elsif player_throw == computer_throw
				"Empatastes"
				elsif computer_throw == @defeat[player_throw]
				"Ganaste; #{player_throw} vence a #{computer_throw}."
				else
				"Perdistes; #{computer_throw} vence a #{player_throw}."
			end

			res = Rack::Response.new
			res.write <<-"EOS"
			<html>
				<title>Juego Piedra, Papel y Tijeras.</title>
			<body>
				<h1>
					#{anwser}
					#{@choose}
				</h1>
			</body>
			</html>
			EOS
			res.finish
		end
	end
end

if $0 == __FILE__

	#Rack::Handler::WEBrick.run Ver_Tweets.new #
	Rack::Server.start(
  		:app => RockPaperScissors::App.new,
  		:Port => 8000,
  		:server => 'thin'
	 )
end
