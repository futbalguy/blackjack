# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    @get('playerHand') .on("bust", @gameOver,@)
    @get('playerHand') .on("stand", @checkScore,@)

  gameOver: (win) ->
    console.log "win" if win
    console.log "loss" if !win

  checkScore: () ->
    debugger
    playerScore = @get('playerHand') .getMaxScore()
    dealerScore = @get('dealerHand') .getMaxScore()
    if playerScore > dealerScore
      @gameOver(true)
    else @gameOver(false)
