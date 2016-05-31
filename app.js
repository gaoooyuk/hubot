var TB = require('./twitterBot')

var config = {
    consumer_key: '',
    consumer_secret: '',
    access_token: '',
    access_token_secret: '',
    timeout_ms: 5 * 60 * 1000,
}

var twitterBot = new TB(config)

twitterBot.prune(10, function(res) {
	console.log("Prune: ", res)
})