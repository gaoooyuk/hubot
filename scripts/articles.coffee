extractor = require 'node-reading'

module.exports = (robot) ->
	robot.respond /articles info (.*)/i, (msg) ->
		url = msg.match[1]
		extractor.extractData url, (err, article) ->
			msgData = {
				channel: msg.message.room
				text: "*Article Summary*"
				attachments: [
					{
					  title: "Title"
					  text: "#{article.title}"
					  mrkdwn_in: ["text"]
					},
					{
					  title: "Author"
					  text: "#{article.author}"
					  mrkdwn_in: ["text"]
					},
					{
					  title: "Summary"
					  text: "#{article.summary}"
					  mrkdwn_in: ["text"]
					},
					{
					  title: "Word Count"
					  text: "#{article.wordCount}"
					  mrkdwn_in: ["text"]
					},
					{
					  title: "Difficulty"
					  text: "#{article.difficulty}"
					  mrkdwn_in: ["text"]
					},
					{
					  title: "Minutes"
					  text: "#{article.minutes}"
					  mrkdwn_in: ["text"]
					}
				]
			}

			robot.adapter.customMessage msgData
	
	robot.respond /articles summary/i, (msg) ->
		msg.send "*Summary* for *Articles*"