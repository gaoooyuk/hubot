//
//  Twitter Bot
//  Helping user acquisition
//

var Twit = require('twit')

var Bot = module.exports = function(config) {
    this.twit = new Twit(config)
};

// Bot APIs

Bot.prototype.setAuth = function(auth) {
    this.twit.setAuth(auth)
}

//
//  prune your followers list
//  randomly unfollow N friends that hasn't followed you back
//
Bot.prototype.prune = function(n, callback) {
    var self = this

    self.twit.get('followers/ids', function(err, reply) {
        if (err) {
            return callback(err)
        }

        var followers = reply.ids

        self.twit.get('friends/ids', function(err, reply) {
            if (err) {
            	return callback(err)
            }

            var friends = reply.ids
            var candidates = inAButNotInB(friends, followers)
            var targets = candidates
            var l = Math.min(n, candidates.length)
            if (l === n && n !== candidates.length) {
            	targets = getRandomSubset(candidates, l)
            }

            var nUnfollowed = 0
            var nErr = 0
            for (var i = 0; i < l; i++) {
            	var target = targets[i]
            	self.twit.post('friendships/destroy', { id: target }, function(err, data, response) {
                    if (err) {
                        nErr++
                    } else {
                        nUnfollowed++
                    }
                    
                    if ((nUnfollowed + nErr) >= l) {
                        callback("done with " + nErr + " failed")
                    }
                })
            }
        });
    });
}

//
// follow n friends from one user's followers
// designed to follow competitors' followers
//
Bot.prototype.gain = function(n, competitor, callback) {
    var self = this

    self.twit.get('followers/ids', { screen_name: competitor }, function(err, reply) {
        if (err) {
            return callback(err)
        }

        var followers = reply.ids

        self.twit.get('friends/ids', function(err, reply) {
            if (err) {
                return callback(err)
            }

            var friends = reply.ids
            var candidates = inAButNotInB(followers, friends)
            var targets = candidates
            var l = Math.min(n, candidates.length)
            if (l === n && n !== candidates.length) {
                targets = getRandomSubset(candidates, l)
            }

            var nFollowed = 0
            var nErr = 0
            for (var i = 0; i < l; i++) {
                var target = targets[i]
                self.twit.post('friendships/create', { id: target }, function(err, data, response) {
                    if (err) {
                        nErr++
                    } else {
                        nFollowed++
                    }
                    
                    if ((nFollowed + nErr) >= l) {
                        callback("done with " + nErr + " failed")
                    }
                })
            }
        });
    });
}

//
// tweet
//
// Bot.prototype.tweet = function(t, callback) {
    
// }

function randIndex(arr) {
  var index = Math.floor(arr.length * Math.random())
  return arr[index]
}

function inAButNotInB(A, B) {
	var elements = A.filter(function(el) {
		return B.indexOf(el) < 0
	})

	return elements
}

function getRandomSubset(arr, size) {
    var shuffled = arr.slice(0), i = arr.length, temp, index;
    while (i--) {
        index = Math.floor((i + 1) * Math.random());
        temp = shuffled[index];
        shuffled[index] = shuffled[i];
        shuffled[i] = temp;
    }
    return shuffled.slice(0, size);
}
