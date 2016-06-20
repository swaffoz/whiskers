$(document).ready ->
  menuToggle = $('#js-mobile-menu').unbind()
  $('#js-navigation-menu').removeClass 'show'
  menuToggle.on 'click', (e) ->
    e.preventDefault()
    $('nav').addClass 'dark'
    $('#js-navigation-menu').slideToggle ->
      if $('#js-navigation-menu').is(':hidden')
        $('#js-navigation-menu').removeAttr 'style'
        $('nav').removeClass 'dark'
      return
    return
  return
