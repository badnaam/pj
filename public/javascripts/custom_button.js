$j(document).ready(function() {
    $j(".fg-button:not(.ui-state-disabled)")
    .hover(
        function(){
            $j(this).addClass("ui-state-hover");
        },
        function(){
            $j(this).removeClass("ui-state-hover");
        }
        )
    .mousedown(function(){
        $j(this).parents('.fg-buttonset-single:first').find(".fg-button.ui-state-active").removeClass("ui-state-active");
        if( $j(this).is('.ui-state-active.fg-button-toggleable, .fg-buttonset-multi .ui-state-active') ){
            $j(this).removeClass("ui-state-active");
        }
        else {
            $j(this).addClass("ui-state-active");
        }
    })
    .mouseup(function(){
        if(! $j(this).is('.fg-button-toggleable, .fg-buttonset-single .fg-button,  .fg-buttonset-multi .fg-button') ){
            $j(this).removeClass("ui-state-active");
        }
    });

});
