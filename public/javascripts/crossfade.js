//Images and alt text - needs to be the same number in each
var images = ['/images/facts/fact_1.gif','/images/facts/fact_2.gif','/images/facts/fact_3.gif','/images/facts/fact_4.gif'];
var alttext = ["1 billion people still can't access clean drinking water","Every litre of Thisty Planet water purchased generates 100,000 litres of clean water","When you buy Thisty Planet, your donation is guaranteed and stated on the pack","By 2015 we're aiming to provide clean water for over 10 million people"];


//Store current image number
var currentIndex = 0;
var nextIndex = 1;
var timeOutDelay = 6000;//Delay in milliseconds
var currentOpacity = new Array();
var FADE_STEP = 2;
var FADE_INTERVAL = 20;
var pause = false;
var browsertype;
var COUNTER;

//Store current image number
var currentIndex = 0;
var nextIndex = 1;
//Delay in milliseconds
var timeOutDelay = 3500;
var currentOpacity = new Array();
var FADE_STEP = 2;
var FADE_INTERVAL = 20;
var pause = false;
var browsertype;
var COUNTER;

//Initialise slideshow if the objects exist for it to work
function startSlideshow() {
	if (!document.getElementsByTagName || !document.getElementById || !document.getElementById('facts_slideshow')) {
		return false;
	}
	currentOpacity[0]=99;
	for(i=1; i<images.length; i++) {
		currentOpacity[i]=0;
	}

	var slideshow = document.getElementById('facts_slideshow');
	//remove existing image
	//slideshow.removeChild(slideshow.firstChild);
	var agt = navigator.userAgent.toLowerCase();
	var is_opera = (agt.indexOf("opera") != -1);
	//Browser check
	if(document.all && !is_opera) {
		browsertype = 'ie';
		//alert('ie');
	} else if (document.all && is_opera) {
		browsertype = 'opera';
		//alert('opera');
	} else {
		browsertype = 'moz';
		//alert('moz');
	}
	
	for(i=0; i<images.length; i++) {
		
		var newimage = document.createElement('IMG');
		newimage.setAttribute('id','image' + i);
		newimage.setAttribute('src',images[i]);
		newimage.setAttribute('alt',alttext[i]);
		newimage.className = "imgfade";
		
		slideshow.appendChild(newimage);

		if (browsertype == 'ie') {
			newimage.style.filter="alpha(opacity=0)";
		} else if (browsertype == 'moz') {
			newimage.style.MozOpacity = 0;
			newimage.style.opacity = 0;
		} else {
			newimage.style.visibility = 'hidden'
		}
	}

	//activate first image and hide original
	slideshow.removeChild(slideshow.firstChild);
	if (browsertype == 'ie') {
		document.getElementById('image'+currentIndex).style.filter="alpha(opacity=100)";
	} else if (browsertype == 'moz') {
		document.getElementById('image'+currentIndex).style.MozOpacity = .99;
		document.getElementById('image'+currentIndex).style.opacity = .99;
	} else {
		document.getElementById('image'+currentIndex).style.visibility = 'visible'
	}

	COUNTER = setTimeout("swapImage()",timeOutDelay);
}

function swapImage() {
	COUNTER = "";
	if (browsertype == 'ie') {
		doFade =  setInterval("crossFade()",FADE_INTERVAL);
	} else if (browsertype == 'moz') {
		doFade =  setInterval("crossFade()",FADE_INTERVAL);
	} else {
		document.getElementById('image'+currentIndex).style.visibility = 'hidden';
		document.getElementById('image'+nextIndex).style.visibility = 'visible';
		currentIndex = nextIndex;
		nextIndex++;
		if(nextIndex == images.length) { 
			nextIndex=0;
		}
	}
	COUNTER = setTimeout("swapImage()",timeOutDelay);
}

function crossFade() {
	currentOpacity[currentIndex]-=FADE_STEP;
	currentOpacity[nextIndex] += FADE_STEP;

	if(document.all) {
		document.getElementById('image'+currentIndex).style.filter = "alpha(opacity=" + currentOpacity[currentIndex] + ")";
		document.getElementById('image'+nextIndex).style.filter = "alpha(opacity=" + currentOpacity[nextIndex] + ")";
	} else {
		document.getElementById('image'+currentIndex).style.MozOpacity = currentOpacity[currentIndex]/100;
		document.getElementById('image'+nextIndex).style.MozOpacity =currentOpacity[nextIndex]/100;
		//Safari
		document.getElementById('image'+currentIndex).style.opacity = currentOpacity[currentIndex]/100;
		document.getElementById('image'+nextIndex).style.opacity =currentOpacity[nextIndex]/100;
	}

	if(currentOpacity[nextIndex]/100>=.98) {
		currentIndex = nextIndex;
		nextIndex++;
		window.clearInterval(doFade);
		if(nextIndex == images.length) { 
			nextIndex=0;
		}
	}
}

//Add onload event to page
addLoadEvent(startSlideshow);