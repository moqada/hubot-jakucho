path = require 'path'
Helper = require 'hubot-test-helper'
assert = require 'power-assert'
sinon = require 'sinon'

describe 'jakucho', ->
  room = null
  user = 'moqada'

  beforeEach ->
    hubotScripts = path.resolve 'node_modules', 'hubot-help', 'src'
    helper = new Helper('./../src/jakucho.coffee')
    room = helper.createRoom()
    room.robot.loadFile hubotScripts, 'help.coffee'

  afterEach ->
    room.destroy()

  describe 'help', ->
    it 'should have 3', ->
      assert room.robot.helpCommands().length is 3

    context 'should parse help jakucho', ->
      beforeEach ->
        room.user.say user, 'hubot help jakucho'
      it 'is expected', ->
        assert.deepEqual room.messages, [
          ['moqada', 'hubot help jakucho'],
          ['hubot', '<SESSHO words> - Reply jakucho image.']
        ]

  describe 'seppo reply', ->
    context '1 sessho words', ->
      beforeEach ->
        room.user.say user, '殺す'
      it 'should reply image received sessho words', ->
        assert room.messages.length is 2
        response = room.messages[1]
        assert response[0] is 'hubot'
        assert response[1].match /^@moqada http:\/\/i\.imgur\.com\//

    context '4 sessho words', ->
      beforeEach ->
        room.user.say user, '殺す'
        room.user.say user, 'fuck'
        room.user.say user, 'ファック'
        room.user.say user, '死ね'
      it 'room.say should reply special image received sessho words 4 times', ->
        assert room.messages.length is 8
        room.messages.slice(4, -1).forEach (res) ->
          assert res[0] is 'hubot'
          assert res[1].match /^@moqada http:\/\/i\.imgur\.com\//
        lastMsg = room.messages.slice(-1)[0]
        assert lastMsg[0], 'hubot'
        assert lastMsg[1].match /^@moqada 仏の顔も三度まで!!! http:\/\/i\.imgur\.com\//
    context '6 sessho words', ->
      beforeEach ->
        room.user.say user, '殺す'
        room.user.say user, 'fuck'
        room.user.say user, 'ファック'
        room.user.say user, '死ね'
        room.user.say user, '死ね'
        room.user.say user, '死ね'
      it 'should reply youtube movie received sessho words 6 times', ->
        assert room.messages.length is 12
        room.messages.slice(6, -3).forEach (res) ->
          assert res[0] is 'hubot'
          assert res[1].match /^@moqada http:\/\/i\.imgur\.com\//
        room.messages.slice(9, -1).forEach (res) ->
          assert res[0] is 'hubot'
          assert res[1].match /^@moqada 仏の顔も三度まで!!! http:\/\/i\.imgur\.com\//
        lastMsg = room.messages.slice(-1)[0]
        assert lastMsg[0], 'hubot'
        assert lastMsg[1].match /^@moqada https?:\/\/www.youtube.com/

    context 'no sesho words', ->
      beforeEach ->
        room.user.say user, '平和'
      it 'should through no sessho words', ->
        assert.deepEqual room.messages, [
          ['moqada', '平和']
        ]

  describe 'seppo count', ->
    clock = null
    beforeEach ->
      clock = sinon.useFakeTimers()
      room.user.say user, '殺す'
      room.user.say user, 'fuck'
      room.user.say user, 'ファック'

    afterEach ->
      clock.restore()

    context 'after 1 day', ->
      beforeEach ->
        clock.tick 24 * 60 * 60 * 1000
        room.user.say user, '死ね'

      it 'should reset', ->
        lastMsg = room.messages.slice(-1)[0]
        assert lastMsg[0] is 'hubot'
        assert lastMsg[1].match /^@moqada http:\/\/i\.imgur\.com\//
