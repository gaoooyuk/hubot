HubotSlack = require 'hubot-slack'
TB = require('../twitterBot')

competitors = [
  'FinWizApp'
  'candlesticksapp'
  'StockioApp'
  'ballstreet_'
  'TitanTradeEN'
  'triggerfinance'
  'StockSwipe'
  'EyeOnMyStocks'
  'Stash'
  'TechnicianApp'
  '3eyeinvestology'
  'StockMobi_App'
  'ShareholderApp'
  'GetStocks'
  'SparkFin'
  'MarketParse'
  'mometicmobile'
  'InvestWall'
  'GoFinanceApp'
  'LoveStocksApp'
  'BatonInvesting'
  'qstockstracker'
  'ClosingBellCo'
  'bux'
  'ZimStocks'
  'stockpulp'
  'DriveWealth'
  'stockspotcomau'
  'investFeed'
  'RobinhoodApp'
  'simplywallst'
  'Ustocktrade'
  'Stocks_Live'
  'InvestProfits'
  'investornetwork'
  'Barchart'
  'StockTwits'
]

config = 
  consumer_key: '4V3XitczeERMNOzbNs75zX72r'
  consumer_secret: 'Dx3g5VHRwekxRqHkCkKSOI3pczof8clj15fxe2fQKUq3mJBQWe'
  access_token: '4915855254-9tRQTHgKRqENQ4soB3mimRoznrAVdMtgsjl6Aqf'
  access_token_secret: '0W7BtqRbWqSVR7kvZVsKmLOrJOaSQviI3vn6q1DtGDNVd'
  timeout_ms: 60 * 1000

twitterBot = new TB(config)

module.exports = (robot) ->
  robot.hear /twitter prune (.*)/i, (msg) ->
    n = msg.match[1]
    twitterBot.prune n, (res) ->
      msg.send "Prune *#{res}*"

  robot.hear /twitter gain (.*)/i, (msg) ->
    n = msg.match[1]
    c = msg.random competitors
    twitterBot.gain n, c, (res) ->
      msg.send "Gain *#{res}*"

  robot.hear /twitter -sc (.*) (.*)/i, (msg) ->
    key = msg.match[1]
    value = msg.match[2]
    robot.brain.set key, value
    cfg = {}
    cfg[key] = value
    twitterBot.setAuth cfg
    msg.send "Twitter *Auth* Updated"

  robot.hear /twitter -gc (.*)/i, (msg) ->
    key = msg.match[1]
    cfg = {}
    if key is "all"
      cfg['consumer_key'] = robot.brain.get('consumer_key')
      cfg['consumer_secret'] = robot.brain.get('consumer_secret')
      cfg['access_token'] = robot.brain.get('access_token')
      cfg['access_token_secret'] = robot.brain.get('access_token_secret')
    else
      cfg[key] = robot.brain.get(key)
      
    cfgStr = JSON.stringify(cfg)
    msg.send "Twitter *Auth* #{cfgStr}"