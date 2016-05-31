enterGreetings = ['How are you doing?']

module.exports = (robot) ->
	robot.enter (msg) ->
		greeting = msg.random enterGreetings
		msg.send "#{greeting} Say `help` to get started or `summary` to get VNK metrics."
	robot.respond /help/i, (msg) ->
		msg.send "I know following commands for VNK"
	robot.respond /summary/i, (msg) ->
		msg.send "*Summary* for *VNK* - Gimletech - Value | iOS"