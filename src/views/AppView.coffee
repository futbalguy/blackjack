class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button>
    <button class="stand-button">Stand</button>
    <button class="deal-button">Deal New Hand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
    <div class="deck-container"></div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('playerHand').stand()
    'click .deal-button': -> @model.newGame()

  initialize: ->
    @render()

    @model.on('change:inProgress', () ->
      @$('.hit-button') .prop("disabled",!@model.get('inProgress'))
      @$('.stand-button') .prop("disabled",!@model.get('inProgress'))
    , @)

    @model.on('gameOver', (result) ->
      if result == 'win'
        $('.player-hand-container .card').solitaireVictory();
    , @)

    @model.on('newHand', () ->
      $('.solitaire-victory-clone').remove()
      @render()
      @addListeners()
    , @)

    @addListeners()


  addListeners: =>
    @model.get('playerHand').on('willHit',() ->
      startLeftPos = $('.deck .card').last().offset().left
      startTopPos = $('.deck .card').last().offset().top

      endLeftPos = $('.player-hand-container .card').last().offset().left + $('.player-hand-container .card').outerWidth(true)
      endTopPos = $('.player-hand-container .card').last().offset().top

      deck = @model.get('deck')
      cardView = new CardView(model: deck.at(deck.length - 1))
      @$el.append(cardView.el)
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
      @$el.append(cardView.el)
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


  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$('.deck-container').html new DeckView(collection: @model.get 'deck').el


