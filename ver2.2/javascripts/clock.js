

var timeBar;

$(function() {
	timeBar = document.getElementById('footer_time');
	setInterval("clock()",1000);
	
});


function clock() {
	var now  = new Date();
	var hour = now.getHours(); 		// hour
	var min  = now.getMinutes();	// minute
	var sec  = now.getSeconds(); 	// second

	if(hour < 10) { hour = "0" + hour; }
	if(min < 10) { min = "0" + min; }
	if(sec < 10) { sec = "0" + sec; }	
	var clock1 = hour + ':' + min + ':' + sec;
	
	// div id="clock-01"
	timeBar.innerHTML = clock1.toLocaleString();
}