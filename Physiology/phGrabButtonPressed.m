function phGrabButtonPressed
% initiates or aborts a physiology package acquisition

	global state gh
	
	buttonString=get(gh.physControls.startButton, 'String');
	if strcmp(buttonString, 'GRAB')
		if ~savingInfoIsOK(1)
			return
		end	
		
 		set(gh.physControls.startButton, 'String', 'ABORT');
		set(gh.physControls.startButton, 'Enable', 'on');        
        drawnow
        
		timerCallPackageFunctions('FirstSetup', 'Physiology');
		timerCallPackageFunctions('Setup', 'Physiology');
        timerSession_resolveTriggers
        timerSetTriggerMaster_Physiology;
		timerCallPackageFunctions('Start', 'Physiology');
        timerCallPackageFunctions('Trigger', 'Physiology');
        timerCallPackageFunctions('SessionWait', 'Physiology');
	elseif strcmp(buttonString, 'end acq')
        global physInputSession
		state.phys.internal.stopInfiniteAcq=1;	
        if physInputSession.IsRunning
        	setPhysStatusString('waiting for input');
            physInputSession.wait(state.phys.settings.runViewSliceDuration);
        end
    
        physInputSession.release();
		state.phys.internal.abort=1;
	    timerCallPackageFunctions('Abort', 'Physiology');
	else
		state.phys.internal.abort=1;
        timerCallPackageFunctions('Abort', 'Physiology');
	end