http = require 'http'
CheckWhitelistMessageFrom = require '../'

describe 'CheckWhitelistMessageFrom', ->
  beforeEach ->
    @whitelistManager =
      checkMessageFrom: sinon.stub()

    @sut = new CheckWhitelistMessageFrom
      whitelistManager: @whitelistManager

  describe '->do', ->
    describe 'when the auth.uuid does not match the fromUuid', ->
      beforeEach (done) ->
        @whitelistManager.checkMessageFrom.yields null, true
        job =
          metadata:
            auth:
              uuid: 'dim-green'
              token: 'blue-purple'
            toUuid: 'bright-green'
            fromUuid: 'frog'
            responseId: 'yellow-green'
        @sut.do job, (error, @newJob) => done error

      it 'should get have the responseId', ->
        expect(@newJob.metadata.responseId).to.equal 'yellow-green'

      it 'should get have the status code of 403', ->
        expect(@newJob.metadata.code).to.equal 403

      it 'should get have the status of 403', ->
        expect(@newJob.metadata.status).to.equal http.STATUS_CODES[403]

    describe 'when the auth.as does not match the fromUuid', ->
      beforeEach (done) ->
        @whitelistManager.checkMessageFrom.yields null, true
        job =
          metadata:
            auth:
              uuid: 'dim-green'
              token: 'blue-purple'
              as: 'potato'
            toUuid: 'bright-green'
            fromUuid: 'dim-green'
            responseId: 'yellow-green'
        @sut.do job, (error, @newJob) => done error

      it 'should get have the responseId', ->
        expect(@newJob.metadata.responseId).to.equal 'yellow-green'

      it 'should get have the status code of 403', ->
        expect(@newJob.metadata.code).to.equal 403

      it 'should get have the status of 403', ->
        expect(@newJob.metadata.status).to.equal http.STATUS_CODES[403]

    describe 'when called with a valid job', ->
      beforeEach (done) ->
        @whitelistManager.checkMessageFrom.yields null, true
        job =
          metadata:
            auth:
              uuid: 'dim-green'
              token: 'blue-purple'
            toUuid: 'bright-green'
            fromUuid: 'dim-green'
            responseId: 'yellow-green'
        @sut.do job, (error, @newJob) => done error

      it 'should get have the responseId', ->
        expect(@newJob.metadata.responseId).to.equal 'yellow-green'

      it 'should get have the status code of 204', ->
        expect(@newJob.metadata.code).to.equal 204

      it 'should get have the status of ', ->
        expect(@newJob.metadata.status).to.equal http.STATUS_CODES[204]

    describe 'when called with a valid job', ->
      beforeEach (done) ->
        @whitelistManager.checkMessageFrom.yields null, true
        job =
          metadata:
            auth:
              uuid: 'dim-green'
              token: 'blue-purple'
            toUuid: 'bright-green'
            fromUuid: 'dim-green'
            responseId: 'yellow-green'
        @sut.do job, (error, @newJob) => done error

      it 'should get have the responseId', ->
        expect(@newJob.metadata.responseId).to.equal 'yellow-green'

      it 'should get have the status code of 204', ->
        expect(@newJob.metadata.code).to.equal 204

      it 'should get have the status of ', ->
        expect(@newJob.metadata.status).to.equal http.STATUS_CODES[204]

    describe 'when called with a valid job without a from', ->
      beforeEach (done) ->
        @whitelistManager.checkMessageFrom.yields null, true
        job =
          metadata:
            auth:
              uuid: 'green-blue'
              token: 'blue-purple'
            toUuid: 'bright-green'
            responseId: 'yellow-green'
        @sut.do job, (error, @newJob) => done error

      it 'should get have the responseId', ->
        expect(@newJob.metadata.responseId).to.equal 'yellow-green'

      it 'should get have the status code of 422', ->
        expect(@newJob.metadata.code).to.equal 422

      it 'should get have the status of ', ->
        expect(@newJob.metadata.status).to.equal http.STATUS_CODES[422]

    describe 'when called with a valid job without a to', ->
      beforeEach (done) ->
        @whitelistManager.checkMessageFrom.yields null, true
        job =
          metadata:
            auth:
              uuid: 'green-blue'
              token: 'blue-purple'
            fromUuid: 'green-blue'
            responseId: 'yellow-green'
        @sut.do job, (error, @newJob) => done error

      it 'should get have the responseId', ->
        expect(@newJob.metadata.responseId).to.equal 'yellow-green'

      it 'should get have the status code of 422', ->
        expect(@newJob.metadata.code).to.equal 422

      it 'should get have the status of ', ->
        expect(@newJob.metadata.status).to.equal http.STATUS_CODES[422]

    describe 'when called with a valid job with an as', ->
      beforeEach (done) ->
        @whitelistManager.checkMessageFrom.yields null, true
        job =
          metadata:
            auth:
              uuid: 'green-blue'
              token: 'blue-purple'
              as: 'monkey-man'
            toUuid: 'bright-green'
            fromUuid: 'monkey-man'
            responseId: 'yellow-green'
        @sut.do job, (error, @newJob) => done error

      it 'should call the whitelistmanager with the correct arguments', ->
        expect(@whitelistManager.checkMessageFrom).to.have.been.calledWith
          emitter: 'monkey-man'
          subscriber: 'bright-green'

    describe 'when called with a different valid job', ->
      beforeEach (done) ->
        @whitelistManager.checkMessageFrom.yields null, true
        job =
          metadata:
            auth:
              uuid: 'dim-green'
              token: 'blue-lime-green'
            toUuid: 'hot-yellow'
            fromUuid: 'dim-green'
            responseId: 'purple-green'
        @sut.do job, (error, @newJob) => done error

      it 'should get have the responseId', ->
        expect(@newJob.metadata.responseId).to.equal 'purple-green'

      it 'should get have the status code of 204', ->
        expect(@newJob.metadata.code).to.equal 204

      it 'should get have the status of OK', ->
        expect(@newJob.metadata.status).to.equal http.STATUS_CODES[204]

    describe 'when called with a job that with a device that has an invalid whitelist', ->
      beforeEach (done) ->
        @whitelistManager.checkMessageFrom.yields null, false
        job =
          metadata:
            auth:
              uuid: 'puke-green'
              token: 'blue-lime-green'
            toUuid: 'super-purple'
            fromUuid: 'puke-green'
            responseId: 'purple-green'
        @sut.do job, (error, @newJob) => done error

      it 'should get have the responseId', ->
        expect(@newJob.metadata.responseId).to.equal 'purple-green'

      it 'should get have the status code of 403', ->
        expect(@newJob.metadata.code).to.equal 403

      it 'should get have the status of Forbidden', ->
        expect(@newJob.metadata.status).to.equal http.STATUS_CODES[403]

    describe 'when called and the checkMessageFrom yields an error', ->
      beforeEach (done) ->
        @whitelistManager.checkMessageFrom.yields new Error "black-n-black"
        job =
          metadata:
            auth:
              uuid: 'puke-green'
              token: 'blue-lime-green'
            toUuid: 'green-bomb'
            fromUuid: 'puke-green'
            responseId: 'purple-green'
        @sut.do job, (error, @newJob) => done error

      it 'should get have the responseId', ->
        expect(@newJob.metadata.responseId).to.equal 'purple-green'

      it 'should get have the status code of 500', ->
        expect(@newJob.metadata.code).to.equal 500

      it 'should get have the status of Forbidden', ->
        expect(@newJob.metadata.status).to.equal http.STATUS_CODES[500]
