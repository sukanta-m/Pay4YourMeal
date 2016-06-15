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
//= require jquery-ui/tabs
//= require jquery_ujs
//= require bootstrap-sprockets
//= require jquery.form-validator
//= require ckeditor/init

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
        },
        updateIncomingBadge: function(number) {
            if ($('#incomingFeedBadge').length > 0) {
                var user_id = $('#user_id').val();
                setInterval(function () {
                    $.ajax({
                        url: '/api/users/' + user_id + '/unread_blog_count',
                        dataType: 'json',
                        success: function (result) {
                            $('#incomingFeedBadge').html(result.openstruct['unread_blogs_count']);
                        }
                    });
                }, number);
            }

        },
        updateFriendRequestBadge: function(number){
            if ($('#friendRequestBadge').length > 0) {
                var user_id = $('#user_id').val();
                setInterval(function () {
                    $.ajax({
                        url: '/api/friendships/' + user_id + '/friend_request_count',
                        dataType: 'json',
                        success: function (result) {
                            $('#friendRequestBadge').html(result.openstruct['requested_friends_count']);
                        }
                    });
                }, number);
            }
        }
    }
}();

$(function() {
    $.validate();

    htmlbodyHeightUpdate();
    $( window ).resize(function() {
        htmlbodyHeightUpdate();
    });
    $( window ).scroll(function() {
        height2 = $('.main').height();
        htmlbodyHeightUpdate();
    });

    $('#login-form-link').click(function(e) {
        $("#login-form").delay(100).fadeIn(100);
        $("#register-form").fadeOut(100);
        $('#register-form-link').removeClass('active');
        $(this).addClass('active');
        e.preventDefault();
    });

    $('#register-form-link').click(function(e) {
        $("#register-form").delay(100).fadeIn(100);
        $("#login-form").fadeOut(100);
        $('#login-form-link').removeClass('active');
        $(this).addClass('active');
        e.preventDefault();
    });

    $('#menu_expand').on("click", function(){
       elm = $(this).find(".expand_compress")[0]
       if(elm.style.display == "none")
         elm.style.display = 'block';
       else
        elm.style.display = 'none';
    });

    $('body').on('click', '.friend-request-notifiction', function(e) {
        if($("#friendRequestDetailsPopOver").hasClass('hidden')) {
            //showProductDialog('Product Pricing', product_pricing)
            position = $(this).offset()
            height = $(this).height()
            width = $(this).width()
            doc_top = (position.top + height + 0) + 'px'
            left = (position.left - $('#friendRequestDetailsPopOver').width() / 2 + width / 2) + 'px'
            $('#friendRequestDetailsPopOver').removeClass('hidden')
            $("#friendRequestDetailsPopOver").css({
                display: "block",
                top: doc_top,
                left: left
            });
            $('#friendRequestDetailsPopOver .popover-title').html('Details')
            url = $(this).attr('data-href')
            App.blockUI($('#friendRequestDetailsPopOver'));
            $.ajax({
                url: url,
                type: 'GET',
                success: function (result) {
                }
            });
        }
        else
            $("#friendRequestDetailsPopOver").addClass('hidden');
        e.preventDefault()
        return false
    });


    App.updateIncomingBadge(10000);
    App.updateFriendRequestBadge(10000)
});

