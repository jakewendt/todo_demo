/*

	who  : Jake
	when : July 7, 2007
	why  : 

*/

Event.observe(window, 'load', function() {
	$$('.pulse_list').each( function(mylist) {

		var num_items = $$('.pulse_list li').size();				/* this should be fixed as it will be wrong if more than 1 list */
		var i = 1;
		var op_min = 0.2;
		var op_step = 0.05;

		mylist.immediateDescendants().each( function(myitem){
			var cuop = op_min + ( ( ( num_items - i++ ) / num_items ) * (1.0-op_min) );
			myitem.setStyle({opacity: cuop });
		});

		Element.addMethods({
			fade_items: function ( thislist ) {
				$(thislist).immediateDescendants().each( function(myitem){
					var cuop = myitem.getStyle('opacity');
					cuop += op_step;
					if ( cuop > 1.0 ) { cuop = op_min; }
					myitem.setStyle({opacity: cuop });
				});
				setTimeout( function () { $(thislist).fade_items( );}, 50);
			},

			fadeout: function ( thislist ) {
				$(thislist).immediateDescendants().each( function(myitem){
					Effect.Appear( myitem );
					Effect.Fade( myitem );
				});
				setTimeout( function () { $(thislist).fadeout( );}, 50);
			}
		});

		mylist.fade_items ( );
//		Effect.Pulsate(mylist);
//		mylist.fadeout ();

	});
});
