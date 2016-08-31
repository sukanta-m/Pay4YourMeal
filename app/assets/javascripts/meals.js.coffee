# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

addMeal = ->
  $('.meal-lists').on('ajax:beforeSend', '.meal_checkbox', ->
    # get id of element to make visible
    progress_bar_id = '#' + @getAttribute('data-progress-bar')
    console.log("sending")
    $(progress_bar_id).show()
    return
  ).on('ajax:complete', '.meal_checkbox', ->
    # get id of element to hide
    console.log("completed")
    progress_bar_id = '#' + @getAttribute('data-progress-bar')
    $(progress_bar_id).hide()
    return
  ).on 'ajax:complete', '.update_msg', (evt, xhr, options) ->
    console.log(xhr.responseJSON.status)
    # get id of element to contain message
    #update = @getAttribute('data-update')
    #$('#' + update).replaceWith $(xhr.responseText).attr('id', update)
    # cause responses with these classes to fade away...
    #$('.notice').fadeOut 2500
    #$('.error').fadeOut 8000
    return

$(document).ready ->
  addMeal()
