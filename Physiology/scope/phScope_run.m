function phScope_run
	global state
	
    timerRequestPause('Physiology');
    
	state.phys.scope.RsAvg=0;
	state.phys.scope.CmAvg=0;
	state.phys.scope.RInAvg=0;
	state.phys.scope.counter=0;    
	state.phys.daq.scopeTriggerTime=[0 0 0 0 0 0];
    
	updateMinInCell;

    reset=0;
    while ~state.phys.scope.needToStop
        while etime(clock, state.phys.daq.scopeTriggerTime)<1/state.phys.scope.frequency
            if state.phys.scope.needToStop
                phScope_stop;
                return
            end
        end
        
        phTelegraphs_read
        if state.phys.internal.needNewScopeDAQ
            phScope_makeSession;
            state.phys.internal.needNewScopeDAQ=0;
        end
        
        if state.phys.internal.needNewScopeOutput
            phScope_makeOutput;
            state.phys.internal.needNewScopeOutput=0;
        end

        state.phys.daq.scopeSession.queueOutputData(state.phys.scope.output);
        state.phys.daq.scopeTriggerTime=clock;
        
        data=state.phys.daq.scopeSession.startForeground();
        phScope_process(data);
      	state.phys.daq.scopeSession.release;
    end

	state.phys.daq.scopeSession.release;
    phScope_stop;
    timerReleasePause('Physiology');
