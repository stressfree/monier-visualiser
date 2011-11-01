/*!Triptech Visualiser Version 0.0.-1*/

// inspect client browser status and maybe push different scripts or CSS here.
// dimensions (for orientation and tablet/phone/desktop/switch) and hash (for preload/save/konami code)
var iw=$(window).width();
var ih=$(window).height();
var lh=location.hash;
var t1='';
var cs=new Array();
var house='1_';
var res='2_1';
var isl=0;
//initialise pinesnotify
var stack_topleft = {"dir1": "down", "dir2": "right", "push": "top"};

function fitscreen(iw,ih) {
	//for orientation and tablet/phone/desktop/switch
	//screen size
	iw=$(window).width();
	ih=$(window).height();
	im=Math.max(iw,ih);
	//check orientation
	$('#stage').css('background-image','url("../r/'+house+res+'/1.jpg")')
	$('.r').css('height',ih+'px');
	if (iw>ih) {
		// landscape
		isl=0;
		$('#s_0').css('bottom','38px');
		$('#stage').css('height',ih+'px');

		if (iw>1024) {
			nw=(iw+1024)/2
			$('#main').css('width',nw+'px');
		} else {
			$('#main').css('width','100%');
		}
		$('#controls').addClass('land');
		$('#crx').show()
		$('#s_0').hide();
		$('#controls').show();
		$('#h_s').show();
	} else {
		// portrait
		isl=1;
		$('#s_0').css('bottom','38px');
		$('#stage').css('height',ih+'px');
		$('#main').css('width','100%');
		$('#controls').removeClass('land');
		$('#crx').hide()
		$('#s_0').show();
		$('#controls').show();
		$('#h_s').show();
	}
	if (!isl) {

	} else {

	}
	//dynamically size swatches;
	s_0=$('#s_0').css('width').replace('px','')
	nc=parseInt((s_0-10)/185)
	ncc=((s_0-10)/nc)-4
	$('.swatch button').css('width',ncc+'px')

}

$(document).ready(function(){
	// Steps to perform on initialization
	//pnot('Did you know?','Hey!')
	if (location.hash) {
		h=location.hash.split('#')[1].split('+');
		house=h[0]+'_';
		res=h[1]+'_1';
	}
	$('.swatchlist').hide()
	fitscreen(iw,ih);
	
	if (navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPad/i)) {
			$('#vp').attr('content', '<meta name="viewport" content="width=device-width, maximum-scale=1,minimum-scale=1,initial-scale=1">');
			document.body.addEventListener('gesturestart', function () {
				$('#vp').attr('content', '<meta name="viewport" content="width=device-width, minimum-scale=0.25, maximum-scale=1.6,">');
			}, false);
	}    
	$('.swatch button').bind('click', function() {
		selmat(this)
	})
	$('.controls button').bind('click', function() {
		//alert($(this).attr('id'))
		
	})
//  	$('.swatch').hide()
})
$(window).bind('orientationchange', function(event) {
	//check in case orientation change not yet reflected in window attr -then preempt
	setTimeout('fitscreen(iw,ih)',200)
	if (navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPad/i)) {
	$('#vp').attr('content', '<meta name="viewport" content="width=device-width, maximum-scale=1,minimum-scale=1,initial-scale=1">');
	}
});
function unscaleme() {
	$('#vp').attr('content', '<meta name="viewport" content="width=device-width, maximum-scale=1,minimum-scale=1,initial-scale=1">');
}
function scaleme() {
	$('#vp').attr('content', '<meta name="viewport" content="width=device-width, minimum-scale=0.25, maximum-scale=1.6,">');
}

function noti(el) {
pnoti=$.pnotify({
					pnotify_text: "Hey, you touched control "+el,
					pnotify_addclass: "stack-topleft",
					pnotify_history: false,
					pnotify_stack: stack_topleft,
					pnotify_notice_icon: '',
					pnotify_delay: 1000
					})
				}
function panelon() {
	// shows selection panel and hides 
	if (!isl) {
// 		$('#s_0').slideDown();
		//$('#s_1').slideDown();
//		$('#controls').slideUp();
//		$('#h_s').slideUp();
	} else {
// 		$('#s_0').slideDown();
	}
	$('#s_0').show()
}

function paneloff() {
	if (!isl) {
		$('#s_0').slideUp();
		$('#controls').slideDown();
		$('#h_s').slideDown();
		$('.sel_').removeClass('sel_')
	} else {
		$('.sel_').removeClass('sel_')
	}
	cs[0]=''
}

function phonehome() {
	noti('Great big pile of information about Home & Save going to go in here')
}
function sel(el) {
	t=el.id.split('_')
	t1='#s_'+t[1]+'_'+t[2]
	t2='#s_'+t[1]+'_0'
	pt1='#pt_'+t[1]+'_1'
	pt2='#pt_'+t[1]+'_2'
	console.log (t1)
	thisg=t2;
	$(t2).slideUp('', function() {
		$(pt1).removeClass('mainbut_on')
		$(pt2).fadeIn('slow')
		$(t1).slideDown()
	});
}

function sl(el) {
// select swatch panel to use
		sw0=el.id.toString()
		swl=sw0.split('_')[1]
	if (!cs[0]||cs[0]!=sw0.split('_')[2]) {
		cs[0]=sw0.split('_')[2]
		showsel(swl)
		$('#s_0').slideUp('', function() {
			// Animation complete.
				if (!t1) {$('#s_'+swl+'_0').show()}
				$('.swatchlist').hide()
				/* Hack here to show mortar*/
				if(swl==1) {$('#s_2').show()}
				$('#s_'+swl).show()
			$('#s_0').slideDown()
		});
		$('.sel_').removeClass('sel_')
		$(el).addClass('sel_')
	} else {
		paneloff()
	}
}

function sg(el) {
// drill into group
	t=el.id.split('_')
	t2='#s_'+t[1]+'_0'
	pt1='#pt_'+t[1]+'_1'
	pt2='#pt_'+t[1]+'_2'
	console.log (t1)
	
	$(t1).slideUp('', function() {
		$(pt1).addClass('mainbut_on')
		$(pt2).fadeOut('slow')
		$(t2).slideDown()
	});
	t1=''
	
	
}
function selmat(el) {
// selects material
	t=el.id.split('_')
	
	if (!t[2]) {
		/* hack here for mortar*/
		pid=$(el).parent().attr('id').split('_')[1]
		if (pid=='2') {
			cs0=parseInt(cs[0])+1
			twk='m'
		} else {
			cs0=parseInt(cs[0])
			twk=''
		}
		cs[cs0]=t[1]
		showsel(t[1])
		console.log('#r_'+cs[0]+twk+'==='+cs[0])
		$('#r_'+cs[0]+twk).css('background-image','url("../r/'+house+res+'/'+cs0+'_'+t[1]+'.png")')
		window.location='#'+house.substring(0,1)+'+'+res.substring(0,1)+'+'+t[1]
		
	}
	
}

function showsel(pane) {
// refresh selected item on current swatch
	$('.sel').removeClass('sel')
	if (cs[0]=='1'||cs[0]=='10') {
		cs00=parseInt(cs[0])+1
		if(cs[cs00]) {$('#sw_'+cs[cs00]).addClass('sel')}
	}
	if(cs[cs[0]]) {$('#sw_'+cs[cs[0]]).addClass('sel')}
	
	
}