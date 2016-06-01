child_process = require 'child_process'

module.exports = (robot) ->
	robot.respond /blog sync/i, (msg) ->
		try
			msg.send "Blog: git pull..."
			child_process.exec 'git pull', { cwd: '/VNK/value/blog/' }, (error, stdout, stderr) ->
				if error
					msg.send "Blog: git pull failed: " + stderr
				else
					output = stdout + ''
					if not /Already up\-to\-date/.test output
						msg.send "Blog: source code changed:\n" + output
					else
						msg.send "Blog is up-to-date"
		catch error
			msg.send "Blog: git pull failed: " + error