# Description
#   Reply jakucho image when you say SESSHO words
#
# Configuration:
#   HUBOT_JAKUCHO_RESET_TIME - reset seppo count. (default: 1 day)
#
# Commands:
#   <SESSHO words> - Reply jakucho image.
#
# Author:
#   moqada@gmail.com

resources = require './data/resources.json'
key = 'jakucho'
resetTime = process.env.HUBOT_JAKUCHO_RESET_TIME or 24 * 60 * 60 * 1000

module.exports = (robot) ->

  robot.brain.on 'loaded', ->
    robot.brain.data[key] ||= {statuses: {}}

  robot.hear /殺|死|fuck|ファック|ﾌｧｯｸ/i, (msg) ->
    data = syncCount msg.message.user
    if data.count > 5
      msg.reply msg.random resources.movie
    else if data.count > 3
      msg.reply "仏の顔も三度まで!!! #{msg.random resources.special}"
    else
      msg.reply msg.random resources.normal

  syncCount = (user) ->
    data = robot.brain.get(key) or {statuses: {}}
    statuses = data.statuses
    now = new Date()
    status = statuses[user.name] or {count: 0, timestamp: now.toString()}
    if (new Date(status.timestamp).getTime()) + resetTime > now.getTime()
      status.count += 1
    else
      status.count = 1
      status.timestamp = now
    statuses[user.name] = status
    robot.brain.set key, data
    status
