path = require 'path'
{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
sinon = require 'sinon'

describe 'jakucho', ->
  robot = null
  user = null
  beforeEach (done) ->
    robot = new Robot null, 'mock-adapter', yes, 'hubot'
    user = robot.brain.userForId 'moqada', room: 'testroom'
    robot.adapter.on 'connected', ->
      robot.loadFile path.resolve('.', 'src'), 'jakucho.coffee'
      hubotScripts = path.resolve 'node_modules', 'hubot', 'src', 'scripts'
      robot.loadFile hubotScripts, 'help.coffee'
      do waitForHelp = ->
        if robot.helpCommands().length > 0
          do done
        else
          setTimeout waitForHelp, 100
    robot.run()

  afterEach ->
    robot.server.close()
    robot.shutdown()

  describe 'help', ->
    it 'should have 3', ->
      assert robot.helpCommands().length is 3

    it 'should parse help jakucho', ->
      cbSend = sinon.spy robot.adapter, 'send'
      robot.adapter.receive new TextMessage user, '@hubot help jakucho'
      [envelope, string] = cbSend.args[0]
      assert string is '''
      <SESSHO words> - Reply jakucho image.
      '''

  describe 'seppo reply', ->
    it 'should reply image received sessho words', ->
      cbReply = sinon.spy robot.adapter, 'reply'
      robot.adapter.receive new TextMessage user, '殺す'
      [envelope, string] = cbReply.args[0]
      assert envelope.message.user is user
      assert string.match /^http:\/\/i\.imgur\.com\//

    it 'should reply special image received sessho words 4 times', ->
      cbReply = sinon.spy robot.adapter, 'reply'
      robot.adapter.receive new TextMessage user, '殺す'
      robot.adapter.receive new TextMessage user, 'fuck'
      robot.adapter.receive new TextMessage user, 'ファック'
      robot.adapter.receive new TextMessage user, '死ね'
      assert cbReply.callCount is 4
      args = cbReply.args
      assert args[2][1].match /^http:\/\/i.imgur\.com\//
      assert args[3][1].match /^仏の顔も三度まで!!! http:\/\/i\.imgur\.com\//

    it 'should reply youtube movie received sessho words 6 times', ->
      cbReply = sinon.spy robot.adapter, 'reply'
      robot.adapter.receive new TextMessage user, '殺す'
      robot.adapter.receive new TextMessage user, 'fuck'
      robot.adapter.receive new TextMessage user, 'ファック'
      robot.adapter.receive new TextMessage user, '死ね'
      robot.adapter.receive new TextMessage user, '死ね'
      robot.adapter.receive new TextMessage user, '死ね'
      assert cbReply.callCount is 6
      args = cbReply.args
      assert args[5][1].match /https?:\/\/www.youtube.com/

    it 'should through no sessho words', ->
      cbSend = sinon.spy robot.adapter, 'send'
      cbReply = sinon.spy robot.adapter, 'reply'
      robot.adapter.receive new TextMessage user, '平和'
      assert cbSend.called is no
      assert cbReply.called is no

  describe 'seppo count', ->
    clock = null
    beforeEach ->
      clock = sinon.useFakeTimers()

    afterEach ->
      clock.restore()

    it 'should reset', ->
      cbReply = sinon.spy robot.adapter, 'reply'
      robot.adapter.receive new TextMessage user, '殺す'
      robot.adapter.receive new TextMessage user, 'fuck'
      robot.adapter.receive new TextMessage user, 'ファック'
      clock.tick 24 * 60 * 60 * 1000
      robot.adapter.receive new TextMessage user, '死ね'
      assert cbReply.callCount is 4
      args = cbReply.args
      assert args[3][1].match /^http:\/\/i\.imgur\.com\//
