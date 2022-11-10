 function timerTrigger(freshTriggerTime)
	if nargin<1
		freshTriggerTime=1;
	end
	
	global state  
	state.cycle.cycleStatus=2; 	% acquiring
		
	ready=0;
	attemptCounter=0;
	while ~ready
		status=timerCallPackageFunctions('ReadyForTrigger');
		if any(status==0)
			attemptCounter=attemptCounter+1;
			disp('timerTrigger: Timer packages not ready');
			pause(0.01);
			if attemptCounter==10
				timerCallPackageFunctions('Abort');
				disp('timerTrigger: Failed 10 attempts to trigger.  Aborting');
				return
			end
		else
			ready=1;
		end
	end

	state.files.lastAcquisition=state.files.fileCounter;
	state.cycle.lastPositionUsed=state.cycle.currentCyclePosition;
	
    state.internal.epochsUsed(state.epoch)=1;
    timerCallPackageFunctions('Trigger', state.timer.triggerPackage);
	
	setStatusString('Triggered')
	if freshTriggerTime
		triggerTime=clock;
		disp(['Triggered at ' clockToString(triggerTime) ', ' num2str(etime(clock,state.internal.triggerTime)) ' seconds since last acquisition.']);
		state.internal.triggerTime=triggerTime;
	end

	if ~any(timerGetActiveStatus)
		timerRegisterPackageDone([])
	end
	
	