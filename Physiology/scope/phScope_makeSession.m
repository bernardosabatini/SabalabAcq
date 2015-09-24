function phScope_makeSession

	global state
	if ~state.hasDevices
		return
    end
    
    delete(state.phys.daq.scopeSession);
    
    setWave('scopeInput0', 'data', [], 'xscale', [0 1000/state.phys.scope.rate]);
    setWave('scopeInput1', 'data', [], 'xscale', [0 1000/state.phys.scope.rate]);
    setWave('scopeInputFit0', 'data', [], 'xscale', [0 1000/state.phys.scope.rate]);
    setWave('scopeInputFit1', 'data', [], 'xscale', [0 1000/state.phys.scope.rate]);
    
    state.phys.daq.scopeSession=daq.createSession('ni');
    state.phys.daq.scopeSession.Rate=state.phys.scope.rate;

    state.phys.scope.channelSelectionOnReset=state.phys.scope.channelSelection;

    switch  state.phys.scope.channelSelectionOnReset
        case 1
            state.phys.scope.channelsUsed=0;
        case 2
            state.phys.scope.channelsUsed=1;
        case 3
            state.phys.scope.channelsUsed=[0 1];
    end

    for channel=state.phys.scope.channelsUsed
        state.phys.daq.scopeSession.addAnalogInputChannel(...
            state.phys.daq.inputBoard,...
            ['ai' num2str(channel)], ...
            'Voltage'...
            );
        state.phys.daq.scopeSession.Channels(end).Range=[-10 10];
        state.phys.daq.scopeSession.addAnalogOutputChannel(...
            state.phys.daq.outputBoard,...
            ['ao' num2str(channel)] , ...
            'Voltage'...
            );
    end

    


	