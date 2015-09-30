path = require 'path'
{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
sinon = require 'sinon'

describe 'jakucho', ->
  robot = null
  user = null
  adapter = null
  beforeEach (done) ->
    robot = new Robot null, 'mock-adapter', yes, 'hubot'
    adapter = robot.adapter
    user = robot.brain.userForId 'moqada', room: 'testroom'
    robot.adapter.on 'connected', ->
      robot.loadFile path.resolve('.', 'src'), 'jakucho.coffee'
      hubotScripts = path.resolve 'node_modules', 'hubot-help', 'src'
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

    it 'should parse help jakucho', (done) ->
      adapter.on 'send', (envelope, strings) ->
        assert strings[0] is '''
        <SESSHO words> - Reply jakucho image.
        '''
        done()
      adapter.receive new TextMessage user, 'hubot help jakucho'

  describe 'seppo reply', ->
    it 'should reply image received sessho words', (done) ->
      adapter.on 'reply', (envelope, strings) ->
        assert envelope.message.user is user
        assert strings[0].match /^http:\/\/i\.imgur\.com\//
        done()
      adapter.receive new TextMessage user, '殺す'

    it 'should reply special image received sessho words 4 times', (done) ->
      count = 0
      adapter.on 'reply', (envelope, strings) ->
        count += 1
        assert envelope.message.user is user
        if count is 4
          assert strings[0].match /^仏の顔も三度まで!!! http:\/\/i\.imgur\.com\//
          done()
        else
          assert strings[0].match /^http:\/\/i.imgur\.com\//
      adapter.receive new TextMessage user, '殺す'
      adapter.receive new TextMessage user, 'fuck'
      adapter.receive new TextMessage user, 'ファック'
      adapter.receive new TextMessage user, '死ね'

    it 'should reply youtube movie received sessho words 6 times', (done) ->
      count = 0
      adapter.on 'reply', (envelope, strings) ->
        count += 1
        if count is 6
          assert strings[0].match /https?:\/\/www.youtube.com/
          done()
        else
          assert not strings[0].match /https?:\/\/www.youtube.com/
      adapter.receive new TextMessage user, '殺す'
      adapter.receive new TextMessage user, 'fuck'
      adapter.receive new TextMessage user, 'ファック'
      adapter.receive new TextMessage user, '死ね'
      adapter.receive new TextMessage user, '死ね'
      adapter.receive new TextMessage user, '死ね'

    it 'should through no sessho words', (done) ->
      adapter.on 'reply', (envelope, strings) ->
        assert not 'reply'
        done()
      adapter.on 'send', (envelope, strings) ->
        assert not 'send'
        done()
      adapter.receive new TextMessage user, '平和'
      setTimeout ->
        done()
      , 1900

  describe 'seppo count', ->
    clock = null
    beforeEach ->
      clock = sinon.useFakeTimers()

    afterEach ->
      clock.restore()

    it 'should reset', (done) ->
      count = 0
      adapter.on 'reply', (envelope, strings) ->
        count += 1
        if count is 4
          assert strings[0].match /^http:\/\/i\.imgur\.com\//
          done()
        else if count is 3
          clock.tick 24 * 60 * 60 * 1000
      adapter.receive new TextMessage user, '殺す'
      adapter.receive new TextMessage user, 'fuck'
      adapter.receive new TextMessage user, 'ファック'
      adapter.receive new TextMessage user, '死ね'
