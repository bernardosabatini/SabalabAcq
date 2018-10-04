function timerLoop

	global state gh
	val=get(gh.timerMainControls.loop, 'String');
	
	if strcmp(val, 'LOOP')
		if timerPausedStatus
			beep;
			setStatusString('Running. Stop processes');
			return
		end

		if ~savingInfoIsOK
			return
		end	

		setStatusString('Starting loop...');

        state.timer.multipleAbortAttemps=0;
		state.internal.firstTimeThroughLoop=1;
		set(gh.timerMainControls.loop, 'String', 'ABORT');
		set(gh.timerMainControls.doOne, 'String', 'ABORT');
		hideGUI('gh.timerMainControls.doOne');
        timerMainLoop
    else
        timerDoOne
    end



