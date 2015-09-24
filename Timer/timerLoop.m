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

		state.internal.firstTimeThroughLoop=1;
		set(gh.timerMainControls.loop, 'String', 'ABORT');
		hideGUI('gh.timerMainControls.doOne');
        timerMainLoop

    else
		timerCallPackageFunctions('Abort');
		if ~any(state.timer.packageStatus)	% nothing running
			set(gh.timerMainControls.loop, 'String', 'LOOP');
			set([gh.timerMainControls.doOne gh.timerMainControls.loop], 'Visible', 'on');
		end			
	end



