function clock() {
	var now  = new Date();
	var hour = now.getHours(); // hour
	var min  = now.getMinutes(); // minute
	var sec  = now.getSeconds(); // second
	var mili = Math.floor(now.getMilliseconds()/10); //mili second

	if(hour < 10) { hour = "0" + hour; }
	if(min < 10) { min = "0" + min; }
	if(sec < 10) { sec = "0" + sec; }
	if(mili < 10) { mili = "0" + mili; }		
	var clock1 = hour + ':' + min + ':' + sec + ':' + mili;
	
	// div id="clock-01"
	document . getElementById( 'footer_time' ) . innerHTML= clock1 . toLocaleString(); 
	window . setTimeout( "clock()", 1);
}
window.onload = clock;

