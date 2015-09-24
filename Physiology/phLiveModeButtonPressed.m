function phLiveModeButtonPressed
% starts, stops, or aborts continuous acquisition with streaming to disk
	global state gh
	
	buttonString=get(gh.physControls.liveModeButton, 'String');
    
	if strcmp(buttonString, 'live')
		set(gh.physControls.liveModeButton, 'String', 'abort');
    	state.phys.internal.runningMode=1;

        for index=state.phys.internal.acquiredChannels
            setWave(['dataWave' num2str(index)], 'data', []);
        end
        phGrabButtonPressed;
	elseif strcmp(buttonString, 'abort')
        % the code below is for stopping a live (continuous) acquisition,
        % not aborting.  uncomment if that is what we want
% 		state.phys.internal.stopInfiniteAcq=1;	
%         while physInputSession.IsRunning
%             pause(0.05);
%             physInputSession.release();
%         end
		state.phys.internal.abort=1;
	    timerCallPackageFunctions('Abort', 'Physiology');
	else
		state.phys.internal.abort=1;
	    timerCallPackageFunctions('Abort', 'Physiology');
	end
	
	