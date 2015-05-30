class window.AppView extends Backbone.View

  className: 'app'

  template: _.template '
    <div class="deck-container"></div>
    <div class="dealer-hand-container"></div>
    <div class="player-hand-container"></div>
    <div class="buttons">
    <button class="deal-button">Deal New Hand</button>
    <button class="hit-button">Hit</button>
    <button class="stand-button">Stand</button>
    </div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @handleStand()
    'click .deal-button': -> @model.newGame()

  initialize: ->
    @render()

    @model.on('gameOver', (result) ->
      @$('.hit-button') .prop("disabled",true)
      @$('.stand-button') .prop("disabled",true)
      @showGameOverMessage(result)
    , @)
    #   if result == 'win'

    #     $('.player-hand-container .card').solitaireVictory()
    #     $('.dealer-hand-container .card').solitaireVictory()


    @model.on('newHand', () ->
      $('.solitaire-victory-clone').remove()
      @render()
      @addListeners()
      @$('.hit-button') .prop("disabled",false)
      @$('.stand-button') .prop("disabled",false)
    , @)

    @addListeners()

  handleStand: =>
    @$('.hit-button') .prop("disabled",true)
    @$('.stand-button') .prop("disabled",true)
    @model.get('playerHand').stand()


  addListeners: =>
    @model.get('playerHand').on('willHit',() ->
      startLeftPos = $('.deck .card').last().offset().left
      startTopPos = $('.deck .card').last().offset().top

      endLeftPos = $('.player-hand-container .card').last().offset().left + $('.player-hand-container .card').outerWidth(true)
      endTopPos = $('.player-hand-container .card').last().offset().top

      deck = @model.get('deck')
      cardView = new CardView(model: deck.at(deck.length - 1))
      $('body').append(cardView.el)
      context = @
      cardView.$el.css(
        'position': 'absolute'
        'top': startTopPos
        'left' : startLeftPos
        ).animate(
        'top': endTopPos
        'left' : endLeftPos
        , 600
        , "linear"
        , () ->
          context.model.get('playerHand').cardArrived()
          @remove())
    , @)

    @model.get('dealerHand').on('willHit',() ->
      startLeftPos = $('.deck .card').last().offset().left
      startTopPos = $('.deck .card').last().offset().top

      endLeftPos = $('.dealer-hand-container .card').last().offset().left + $('.dealer-hand-container .card').outerWidth(true)
      endTopPos = $('.dealer-hand-container .card').last().offset().top

      deck = @model.get('deck')
      cardView = new CardView(model: deck.at(deck.length - 1))
      $('body').append(cardView.el)
      context = @
      cardView.$el.css(
        'position': 'absolute'
        'top': startTopPos
        'left' : startLeftPos
        ).animate(
        'top': endTopPos
        'left' : endLeftPos
        , 600
        , "linear"
        , () ->
          context.model.get('dealerHand').cardArrived()
          @remove())
    , @)

  showGameOverMessage: (result) ->
    $('.app').append('<div class="gameOverMessage"><h1>YOU<br>'+result.toUpperCase()+'!</h1></div>')


  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$('.deck-container').html new DeckView(collection: @model.get 'deck').el


