function resumeLoop
	global state gh
	updateGuiByGlobal('state.internal.secondsCounter');

	state.cycle.repeatsDone=state.cycle.repeatsDone+1;
	updateGuiByGlobal('state.cycle.repeatsDone');

	if state.cycle.randomize
		state.internal.randomPosition=state.internal.randomPosition+1;
	end
	timerMainLoop;
