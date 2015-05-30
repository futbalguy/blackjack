class window.Card extends Backbone.Model
  initialize: (params) ->
    @set
      revealed: true
      value: if params.rank == 0 or params.rank > 10 then 10 else params.rank
      suitName: ['Spades', 'Diamonds', 'Clubs', 'Hearts'][params.suit]
      rankName: switch params.rank
        when 0 then 'King'
        when 1 then 'Ace'
        when 11 then 'Jack'
        when 12 then 'Queen'
        else params.rank
      fileName: @getFileName(params.rank, params.suit)


  flip: ->
    @set 'revealed', !@get 'revealed'
    @trigger('flipped')
    @

  getFileName: (rank, suit) ->
    suitName = ['Spades', 'Diamonds', 'Clubs', 'Hearts'][suit]
    rankName = switch rank
      when 0 then 'King'
      when 1 then 'Ace'
      when 11 then 'Jack'
      when 12 then 'Queen'
      else rank
    fileString = 'img/cards/' + rankName + '-' + suitName + '.png'
    fileString.toLowerCase()
