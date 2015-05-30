class window.DeckView extends Backbone.View
  className: 'deck'


  initialize: ->
    @render(true)
    @collection.on 'remove', => @render(false)

  render: (showAnimation) ->
    @$el.children().detach()
    if showAnimation
      @$el.append @collection.map (card,index) ->
        card.set('revealed', false)
        cardView = new CardView(model: card)
        cardView.$el.css(
          'top':'0px',
          'left':'0px'
          )
        left = index * 14
        cardView.$el.animate(
          'left':left
          )
    else
      @$el.append @collection.map (card,index) ->
        card.set('revealed', false)
        cardView = new CardView(model: card)
        cardView.$el.css(
          'top':'0px',
          'left':index * 14
          )
