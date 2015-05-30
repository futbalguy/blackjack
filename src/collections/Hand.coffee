class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @trigger('willHit')
    nextCard = @deck.pop()
    nextCard.set('revealed', true)
    @add(nextCard)

    @checkIfBusted()
    nextCard

  stand: ->
    @trigger "stand"

  cardArrived: ->
    @trigger "cardArrived"
    if @isDealer && @getMaxScore() < 17
      @hit()

  # hitUntil17: ->
  #   while @getMaxScore() < 17
  #     @hit()

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]
    #check for more than one ace

  getMaxScore: ->
    #returns highest possible score under 22
    trueScore = @reduce (score, card) ->
      score + if card.get('revealed') then card.get 'value' else 0
    , 0
    trueScores = [trueScore, trueScore + 10 * @hasAce()]
    if trueScores[1] < 22 then trueScores[1]
    else trueScores[0]

  checkIfBusted: () ->
      score = @scores()[0]
      @trigger "bust" if score > 21
