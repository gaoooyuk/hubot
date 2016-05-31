module.exports = (robot) ->
	robot.respond /users (.*)/i, (msg) ->
		cmd = msg.match[1]
		if cmd is "active"
			data = JSON.stringify({ adminKey: "" })
			robot.http("http://gimletech.com/admin/getStatistics")
				.header('Content-Type', 'application/json')
				.post(data) (err, res, body) ->
					d = JSON.parse body
					msg.send "Currently #{d.activedMembers} are active."
		else if cmd is "all"
			data = JSON.stringify({ adminKey: "" })
			robot.http("http://gimletech.com/admin/getStatistics")
				.header('Content-Type', 'application/json')
				.post(data) (err, res, body) ->
					d = JSON.parse body
					msg.send "There are #{d.totalMembersRegistered} users registered."
		else if cmd is "summary"
			data = JSON.stringify({ adminKey: "" })
			robot.http("http://gimletech.com/admin/getStatistics")
				.header('Content-Type', 'application/json')
				.post(data) (err, res, body) ->
					d = JSON.parse body
					msg.send "There are #{d.totalMembersRegistered} users registered. Currently #{d.activedMembers} are active."
		else
			msg.send "Command #{cmd} not implemented"

