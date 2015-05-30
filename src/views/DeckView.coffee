class window.DeckView extends Backbone.View
  className: 'deck'


  initialize: ->
    @render()
    @collection.on 'add remove', => @render()

  render: ->
    @$el.children().detach()
    @$el.append @collection.map (card) ->
      card.set('revealed', false)
      new CardView(model: card).$el

