# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready () ->
  approve_marketing = ->
    $('.approve-marketing').on 'click', () ->
      marketing_id = $(this).attr('id').split('_')[1]
      $.ajax
        url: '/marketings/' + marketing_id + '/approve'
        type: 'PUT'
        success: (res)->
          if(res.is_approved)
            $('#marketing_'+res.id).removeClass('unapproved')
            $('#marketing_'+res.id).addClass('approved')
          else
            $('#marketing_'+res.id).removeClass('approved')
            $('#marketing_'+res.id).addClass('unapproved')
        error: (res)->
          console.log('error')
      return

  approve_marketing()
