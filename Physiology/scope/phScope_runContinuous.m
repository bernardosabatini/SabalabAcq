function phScope_runContinuous
	global state gh
	
    timerRequestPause('Physiology');
    set(gh.scope.start, 'String', 'Stop');
   
	state.phys.scope.RsAvg=0;
	state.phys.scope.CmAvg=0;
	state.phys.scope.RInAvg=0;
	state.phys.scope.counter=0;    
	state.phys.daq.scopeTriggerTime=[0 0 0 0 0 0];
    
	updateMinInCell;

    state.phys.scope.zeroOutput=0*state.phys.scope.output;
    
    reset=0;
    
    state.phys.internal.scopeAbort=0;
    state.phys.daq.scopeSession.addlistener('DataAvailable', @phScope_processDataListener);
    state.phys.daq.scopeSession.IsContinuous=1;
    state.phys.daq.scopeSession.NotifyWhenDataAvailableExceeds=size(state.phys.scope.zeroOutput,1);
    state.phys.daq.scopeSession.NotifyWhenScansQueuedBelow=size(state.phys.scope.zeroOutput,1);
    state.phys.internal.even=1;

        state.phys.daq.scopeSession.queueOutputData(state.phys.scope.output);
        state.phys.daq.scopeSession.queueOutputData(state.phys.scope.zeroOutput);
    %state.phys.daq.scopeSession.queueOutputData(rand(10*size(state.phys.scope.output,1),1))

    state.phys.daq.scopeSession.startBackground();
    
    pause(2);
    state.phys.internal.scopeAbort=1;
    phScope_stop;
