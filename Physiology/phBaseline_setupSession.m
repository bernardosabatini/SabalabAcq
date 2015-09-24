function phBaseline_setupSession
	global state
	if state.analysisMode
		return
    end
	
    if ~isempty(state.phys.daq.baselineSession)
        delete(state.phys.daq.baselineSession);
    end
    
	state.phys.daq.baselineSession=daq.createSession('ni');
    
	for counter=0:1	% add channels for main reading
		type=state.phys.settings.(['channelType' num2str(counter)]);
		if type > 1
            state.phys.daq.baselineSession.addAnalogInputChannel(state.phys.daq.inputBoard, ...
                ['ai' num2str(counter)], 'Voltage');
			state.phys.daq.baselineSession.Channels(end).Range=[-10 10];
		end
	end
	
	for counter=0:1	% add channels for the other one feedback reading of command
		type=state.phys.settings.(['channelType' num2str(counter)]);
		if type > 1
            state.phys.daq.baselineSession.addAnalogInputChannel(state.phys.daq.inputBoard, ...
                ['ai' num2str(counter+2)], 'Voltage');
			state.phys.daq.baselineSession.Channels(end).Range=[-10 10];
		end
    end
	
%     state.phys.daq.baselineSession.Rate=10000;
%     state.phys.daq.baselineSession.DurationInSeconds=0.05;
    
