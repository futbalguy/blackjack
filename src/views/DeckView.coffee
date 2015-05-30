class window.DeckView extends Backbone.View
  className: 'deck'


  initialize: ->
    @render()
    @collection.on 'add remove', => @render()

  render: ->
    @$el.children().detach()
    @$el.append @collection.map (card,index) ->
      card.set('revealed', false)
      left = index * 5
      new CardView(model: card).$el.css({'top':'0px','left',left})

