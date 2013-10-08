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
			@defeat = {'rock' => 'scissors', 'paper' => 'rock', 'scissors' => 'paper'}
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
				"Choose one of the following:"
				elsif player_throw == computer_throw
				"You tied with the computer"
				elsif computer_throw == @defeat[player_throw]
				"Nicely done; #{player_throw} beats #{computer_throw}"
				else
				"Ouch; #{computer_throw} beats #{player_throw}. Better luck next time!"
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
  		:app => Ver_Tweets.new,
  		:Port => 8000,
  		:server => 'thin'
	 )
end
