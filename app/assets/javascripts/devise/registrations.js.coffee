$(document).ready () ->
  validateRegistrationForm = () ->
    $("#registrations_form").validate
      errorElement: "label"
      rules:
        "user[first_name]":
          required: true
        "user[last_name]":
          required: true
        "user[email]":
          required: true
          email: true
        "user[password]":
          required: true
        "user[password_confirmation]":
          required: true
      messages:
        "user[first_name]":
          required: "Required!"
        "user[last_name]":
          required: "Required!"
        "user[email]":
          required: "Required!"
          email: "Invalid email format"
        "user[password]":
          required: "Required!"
        "user[password_confirmation]":
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

  validateRegistrationForm()