function timerAbort_Physiology
	global state gh
    
	state.phys.internal.abort=1;

    global physOutputSession physInputSession
	inputRunning=0;
	if physInputSession.IsRunning
		inputRunning=1;
		physInputSession.stop();
	end

	outputRunning=0;
	if physOutputSession.IsRunning
		outputRunning=1;
		physOutputSession.stop();
	end
		
% 	while physOutputSession.IsRunning || physInputSession.IsRunning
% 		pause(0.05);
% 	end	

    if physInputSession.IsRunning
    	setPhysStatusString('waiting for input');
        disp(' WARNING: If does not progress from this state, ^C and phSession_hardKill');
        physInputSession.wait();
    end
    
    if physOutputSession.IsRunning
    	setPhysStatusString('waiting for output');
        disp(' WARNING: If does not progress from this state, ^C and phSession_hardKill');
        physOutputSession.wait();        
    end
    
    physInputSession.release();
    physOutputSession.release();
	if physOutputSession.ScansQueued>0
		disp('abortPhysiology: there is data queued.  Flushing')
 		physOutputSession.stop();
    end

    if physInputSession.IsContinuous && ...
            state.phys.settings.streamToDisk && state.files.autoSave
        try
            fclose(state.phys.internal.streamFID);
        catch
        end
    end
    
    physOutputSession.release();
    physInputSession.release();
    
	set(gh.physControls.startButton, 'String', 'GRAB');
	set(gh.physControls.liveModeButton, 'String', 'live');	
	pause(0.001);
	set(gh.physControls.startButton, 'Enable', 'on');
	set(gh.scope.start, 'Enable', 'on');
    
	setPhysStatusString('Ready');	
	timerSetPackageStatus(0, 'Physiology');
	timerCheckIfAllAborted;
	state.phys.internal.runningMode=0;