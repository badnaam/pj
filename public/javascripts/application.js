// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

document.observe("dom:loaded", function() {
    $('loading').hide();
//    if ($$('.submit-link-button') != null) {
//        elem = $$('.submit-link-button').first();
//        Event.observe(elem, 'click', function(event) {
//            this.up('form').submit();
//        });
//    }
    Ajax.Responders.register({
        onCreate: function() {
            new Effect.Opacity('main_container', {
                from: 1.0,
                to: 0.3,
                duration: 0.7
            });
            //            new	Effect.toggle('loading', 'appear');
            $('loading').show();

        },
        onComplete: function() {
            new Effect.Opacity('main_container', {
                from: 0.3,
                to: 1,
                duration: 0.7
            });
            //            new	Effect.toggle('loading', 'appear');
            $('loading').hide();
        }
    });

    var container = $(document.body)

    container.observe('click', function(e) {
        var el = e.element()
        if (el.match('.pagination a')) {
            //el.up('.pagination').insert(createSpinner())
            new Ajax.Request(el.href, {
                method: 'get'
            })
            e.stop()
        }
    });

});


