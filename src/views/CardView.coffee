class window.CardView extends Backbone.View
  className: 'card'

  template: _.template '<img class="card-image" src=<%= fileName %> >'

  initialize: -> @render()

  render: ->
    @$el.children().detach()
    if @model.get 'revealed'
      @$el.html @template @model.attributes
    else
      @$el.html('<img class="card-image" src="./img/card-back.png">')

