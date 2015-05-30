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
    @model.on('newHand', () ->
      @render()
    , @)
    @model.get('playerHand').on('willHit',() ->
      startLeftPos = $('.deck .card').last().offset().left
      startTopPos = $('.deck .card').last().offset().top
      endLeftPos = $('.player-hand-container .card').last().offset().left + $('.player-hand-container .card').last().width()
      endTopPos = $('.player-hand-container .card').last().offset().top
      debugger
    )


  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$('.deck-container').html new DeckView(collection: @model.get 'deck').el


