$(document).ready () ->
  validateLoginForm = () ->
    $("#login_form").validate
      errorElement: "label"
      rules:
        "user[email]":
          required: true
          email: true
        "user[password]":
          required: true
      messages:
        "user[email]":
          required: "Required!"
          email: "Invalid email format"
        "user[password]":
          required: "Required!"

      success: (label) ->
        $(label).remove()

      highlight: (element, errorClass) ->
        $(element).parent().next().addClass('note')
        $(element).addClass "error_field"

      unhighlight: (element, errorClass) ->
        $(element).removeClass "error_field"
        $(element).parent().next().removeClass('note')

      errorPlacement: (error, element) ->
        $(element).parent().next().html error

      submitHandler: (form) ->
        form.submit()

  validateLoginForm()