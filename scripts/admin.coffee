module.exports = (robot) ->
	robot.respond /admin (.*)/i, (msg) ->
		cmd = msg.match[1]
		if cmd is "-v"
			data = JSON.stringify({ adminKey: "" })
			robot.http("http://gimletech.com/admin/getServerVersion")
				.header('Content-Type', 'application/json')
				.post(data) (err, res, body) ->
					d = JSON.parse body
					msg.send "VNK version: *#{d.version}*"
		else if cmd is "-rc"
			robot.http("http://gimletech.com/admin/getRemoteConfig")
				.get() (err, res, body) ->
					msg.send "VNK app remote config: *#{body}*"

	robot.respond /admin -sv (.*)/i, (msg) ->
		ver = msg.match[1]
		data = JSON.stringify({ adminKey: "", version: ver })
		robot.http("http://gimletech.com/admin/setServerVersion")
			.header('Content-Type', 'application/json')
			.post(data) (err, res, body) ->
				d = JSON.parse body
				msg.send "VNK version successfully set to *#{ver}*"

	robot.respond /admin -src (.*) (.*)/i, (msg) ->
		k = msg.match[1]
		v = msg.match[2]
		data = JSON.stringify({ adminKey: "", key: k, value: v })
		robot.http("http://gimletech.com/admin/setRemoteConfig")
			.header('Content-Type', 'application/json')
			.post(data) (err, res, body) ->
				d = JSON.parse body
				if d.success == true
					msg.send "VNK - app remote config *#{k}* successfully set to *#{v}*"
				else
					msg.send "VNK - change app remote config *failed*"