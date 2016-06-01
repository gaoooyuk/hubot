child_process = require 'child_process'

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

	robot.respond /admin db (.*)/i, (msg) ->
		cmd = msg.match[1]
		if cmd is "backup"
			try
				msg.send "Database: start backup ..."
				child_process.exec 'mongodump --port 27017 -d ValueDB -o backup', { cwd: '/' }, (error1, stdout1, stderr1) ->
					if error1
						msg.send "DB: dump failed: " + stderr1
					else
						msg.send "(1/3) DB dump success"
						cmt = 'git commit -m ' + (new Date).getTime()
						child_process.exec cmt, { cwd: '/backup/' }, (error2, stdout2, stderr2) ->
							if error2
								msg.send "DB: commit failed: " + stderr2
							else
								msg.send "(2/3) DB commit success"
								child_process.exec 'git push -u origin master', { cwd: '/backup/' }, (error3, stdout3, stderr3) ->
									if error3
										msg.send "DB: backup failed: " + stderr3
									else
										msg.send "(3/3) DB backup success"
			catch error
				msg.send "DB: back up failed: " + error
		else if cmd is "restore"
			msg.send "Warning: VNK database restore rejected"