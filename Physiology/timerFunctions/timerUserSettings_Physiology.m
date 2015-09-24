function timerUserSettings_Physiology
	global state

%	loadPulseSet(state.pulses.pulseSetPath, state.pulses.pulseSetName);
    
    phClamp_processSelection;
    
	if state.hasDevices
        phSession_buildInput;
        phSession_buildOutput(1);
	end


	
