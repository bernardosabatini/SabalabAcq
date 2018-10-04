function setTimerStatusString(st)

	global state
	state.timer.statusString=st;
	updateGuiByGlobal('state.timer.statusString');
	
	