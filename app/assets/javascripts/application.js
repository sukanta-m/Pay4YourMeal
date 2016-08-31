// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require bootstrap-sprockets
//= require jquery.form-validator
//= require jquery_nested_form
//= require bootstrap-datepicker


function htmlbodyHeightUpdate(){
  var height3 = $( window ).height();
  var height1 = $('.nav').height()+50;
  height2 = $('.main').height();
  if(height2 > height3){
    $('html').height(Math.max(height1,height3,height2)+10);
    $('body').height(Math.max(height1,height3,height2)+10);
  }
  else
  {
    $('html').height(Math.max(height1,height3,height2));
    $('body').height(Math.max(height1,height3,height2));
  }

}

function checkGroupExist(){
  return $.ajax({
    url: "/groups/any_group",
    type: 'GET',
    success: function(res) {

    },
    error: function() {

    }
  });
}

var App = function() {
  return {
    blockUI: function (el) {
      el.block({
        message: '',
        css: {
          backgroundColor: 'none'
        },
        overlayCSS: {
          backgroundColor: '#FFFFFF',
          backgroundImage: "url('/assets/ajax-loader.gif')",
          backgroundRepeat: 'no-repeat',
          backgroundPosition: 'center',
          opacity: 0.67
        }
      });
    },
    unBlockUI: function (el) {
      el.unblock();
    }
  }
}();

$(document).ready(function () {

  $.validate();
  checkGroupExist();
  $('.datepicker').datepicker({
    format: "dd/mm/yyyy"
  });

  $("#date_changer").datepicker( {
    format: "dd-mm-yyyy",
    startView: "months",
    minViewMode: "months"
  });

  $(".is-numeric").keypress(function(event) {
    // Backspace, tab, enter, end, home, left, right
    // We don't support the del key in Opera because del == . == 46.
    var controlKeys = [8, 9, 13, 35, 36, 37, 39];
    // IE doesn't support indexOf
    var isControlKey = controlKeys.join(",").match(new RegExp(event.which));
    // Some browsers just don't raise events for control keys. Easy.
    // e.g. Safari backspace.
    if (!event.which || // Control keys in most browsers. e.g. Firefox tab is 0
        (48 <= event.which && event.which <= 57) || // Always 1 through 9
        isControlKey) { // Opera assigns values for control keys.
      return;
    } else {
      event.preventDefault();
    }
  });

  htmlbodyHeightUpdate();
  $( window ).resize(function() {
    htmlbodyHeightUpdate();
  });
  $( window ).scroll(function() {
    height2 = $('.main').height();
    htmlbodyHeightUpdate();
  });
});
