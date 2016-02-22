(function(){

	//TRANSFORM MENU TO FIXED WHEN SCROLLED TO IT
	var wrap = $("nav.widenav");
	var myoffset  = wrap.offset().top;

	$(window).on('scroll', function() {
	  var scrollTop = $(this).scrollTop();


	  if (scrollTop > myoffset) {
	    wrap.addClass("fix-menu");
	  } else {
	    wrap.removeClass("fix-menu");
	  }
	});


	//FADE HEADER IMAGE
	$(window).scroll(function(){
    	$(".fader").css("opacity", 0 + $(window).scrollTop() / 500);
  	});

  	// SMOOTHLY SCROLL TO SECTIONS ------------------------------------------------------------
	$('a[href^="#"]').click(function(e) {

	    e.preventDefault();
			console.log(this)
			console.log(this.hash)
    	$('html,body').animate({ scrollTop: jQuery(this.hash).offset().top-50}, 700);
	    return false;

	});

	$('.mobilenav-trigger').click(function (e) {
		$('.mobilenav').toggleClass('showmenu');
		$('.mobilenav-trigger').toggleClass('menuopen');
		e.preventDefault();
	});


})();
