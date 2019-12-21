function timerDoOne
	global state gh

	state.cycle.cycleStatus=0;

	val=get(gh.timerMainControls.doOne, 'String');
  
	if strcmp(val, 'DO ONE')
		if timerPausedStatus
			beep;
			setStatusString('Running. Stop processes');
			return
		end

		if ~savingInfoIsOK
			return
        end	
        
        state.timer.multipleAbortAttemps=0;
        state.internal.firstTimeThroughLoop=1;
        multipleAbortAttempts=0;
		state.cycle.loopingStatus=0; 	% not a loop
        timerSetCycleActivePackagesStatus
		timerCycle_applyPosition;
%		gotoCycleStagePosition(1);	% force a movement for when they hit DO ONE button
        
		timerCallPackageFunctions('FirstSetup');
		timerCallPackageFunctions('Setup');
        timerSession_resolveTriggers;
		timerCallPackageFunctions('Start');
		
		set(gh.timerMainControls.doOne, 'String', 'ABORT');
		hideGUI('gh.timerMainControls.loop');
		state.timer.abort=0;
        state.internal.firstTimeThroughLoop=0;
		timerTrigger;
        
        timerWaitForSessionEnds;
        if state.timer.abort
        else
            timerRegisterPackageDone;
        end        

	elseif strcmp(val, 'ABORT')
		state.timer.multipleAbortAttemps=state.timer.multipleAbortAttemps+1;
		if state.timer.multipleAbortAttemps>1
			disp('Multiple abort attempts.  Will force abort.');
			timerCallPackageFunctions('ForceAbort');
    		timerCallPackageFunctions('Abort');
        else
        		timerCallPackageFunctions('Abort');
        end
    else
		disp('timerDoOne: Do One button is in unknown state'); 	% BSMOD - error checking
	end
	
	
	
