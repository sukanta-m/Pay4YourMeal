# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready () ->
  validateBlogForm = () ->
    $("#blog_form").validate
      errorElement: "label"
      rules:
        "blog[title]":
          required: true
        "blog[description]":
          required: true
      messages:
        "blog[title]":
          required: "Required!"
        "blog[description]":
          required: "Required!"

      success: (label) ->
        $(label).remove()

      highlight: (element, errorClass) ->
        $(element).parent().next().addClass('note')
        $(element).addClass "error_field"

      unhighlight: (element, errorClass) ->
        $(element).parent().next().removeClass('note')
        $(element).removeClass "error_field"

      errorPlacement: (error, element) ->
        $(element).parent().next().html error

      submitHandler: (form) ->
        form.submit()

  shareBlogWithFriends = ()->
    $('body').on 'click', '#link_share_blog', ()->
      v_url = $(this).attr('data-href')
      $.ajax
        url: v_url
        type: 'GET'
        success: (res)->
          console.log(res)
        error: (res)->
          console.log('error')

  selectFriends = ()->
    $('body').on 'click','#shared_blog_form ul li img', ()->
      checkbox = $(this).parent().find("input[type='checkbox']")
      if checkbox.is(':checked')
        checkbox.prop("checked", false)
        $(this).parent().removeClass('select-friend')
      else
        checkbox.prop("checked",true)
        $(this).parent().addClass('select-friend')

  expandCollapseBlog = ()->
    $('body').on 'click','#expand_collapse_blog',()->
      elm = $(this).parent().find('.post-content')
      if elm.hasClass('collapse-blog')
        elm.removeClass('collapse-blog').addClass('expand-blog')
        $(this).find('span').html('Read less')
      else
        $('html, body').animate { scrollTop: $($(this).parent().next()[0]).offset().top },1000
        elm.removeClass('expand-blog').addClass('collapse-blog')
        $(this).find('span').html('Read more')


  deleteBlog = ()->
    $('body').on 'click','#delete_blog',()->
      value = confirm("Are you sure to delete the blog. Remember this can't be revert back" )
      if value
        App.blockUI($('#main'))
        v_url = $(this).attr('data-href')
        $.ajax
          url: v_url
          type: 'DELETE'
          success: (res)->
            console.log(res)
          error: (res)->
            console.log('error')

  markBlogPublicPrivate = ()->
    $('body').on 'click','#make_private_public',()->
      v_url = $(this).attr('data-href')
      value = false
      if $(this).hasClass('fa-lock')
        value = confirm("Are you sure to mark as public" )
      else
        $(this).hasClass('fa-unlock')
        value = confirm("Are you sure to mark as private" )
      if value
        App.blockUI($('#main'))
        $.ajax
          url: v_url
          type: 'PUT'
          success: (res)->
            console.log(res)
            if res.status == 'success'
              elm = $("#lock_unlock_"+res.blog_id)
              if elm.hasClass('fa-lock')
                elm.removeClass('fa-lock').addClass('fa-unlock')
                elm.attr('title','Click to mark it as private')
              else
                elm.hasClass('fa-unlock')
                elm.removeClass('fa-unlock').addClass('fa-lock')
                elm.attr('title', 'Click to mark it as public')
            App.unBlockUI($('#main'))
          error: (res)->
            console.log('error')
            App.unBlockUI($('#main'))

  shareBlogWithFriends()
  selectFriends()
  expandCollapseBlog()
  deleteBlog()
  markBlogPublicPrivate()
  validateBlogForm()