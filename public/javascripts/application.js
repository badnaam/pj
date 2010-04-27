// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

document.observe("dom:loaded", function() {
    $('loading').hide();

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
});



