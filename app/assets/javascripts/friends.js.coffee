initTabs = ->
  $('#friendsTabs').tabs()
  $('#friendsTabsContainer').removeClass('hidden')

sendFriendRequest = ->
  $('.send-friend-request').on 'click',()->
    v_url = $(this).attr('data-href')
    App.blockUI($('#friendsTabsContainer'))
    $.ajax
      url: v_url
      type: 'POST'
      success: (res)->
        console.log(res)
      error: (res)->
        console.log('error')

acceptFriendRequest = ->
  $('.accept-friend-request').on 'click',()->
    App.blockUI($('#friendsTabsContainer'))
    v_url = $(this).attr('data-href')
    $.ajax
      url: v_url
      type: 'PUT'
      success: (res)->
        App.unBlockUI($('#friendsTabsContainer'))
      error: (res)->
        App.unBlockUI($('#friendsTabsContainer'))

searchFriends = ->
  $('#search').on 'keyup',()->
    data = $(this).val()
    v_url = $(this).attr('data-href') + '?&search_text=' + data
    $.ajax
      url: v_url
      type: 'GET'
      success: (res)->
        console.log(res)
      error: (res)->
        console.log('error')

$(document).ready ->
  initTabs()
  sendFriendRequest()
  acceptFriendRequest()
  searchFriends()