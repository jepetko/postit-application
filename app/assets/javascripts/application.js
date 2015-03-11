// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap

/*
$(document).ready(function() {
    $('#hit_form input').click(function() { //1. unobstrusive javascript
        $.ajax({  //2. trigger ajax request
            type: 'POST',
            url: '/player/hit',
            data: { param1: 'hi', param2: 'there' }
        }).done(function(msg) {     //3. handle the response
            $('#some_element').html(msg);
        });
    });
})
*/

$(document).ready(function () {
    (function ($) {
        $('.upvote-link, .downvote-link').click(function () {
            (function(anchor) {
                $.ajax({
                    type: 'POST',
                    url: anchor.href,
                    dataType: 'json'
                }).done(function (msg) {
                    var span = $(anchor).parent().find('span');
                    span.text(msg['count'] + ' votes');
                    if(span.attr('title') || span.attr('data-original-title')) {
                        span.tooltip('destroy');
                    }
                    span.attr('title', msg['notice'] || msg['error']);
                    span.tooltip('show');
                    setTimeout(function() {
                        span.tooltip('hide');
                    }, 3000);
                });
            })(this);
            return false;
        });
    })(jQuery);
});