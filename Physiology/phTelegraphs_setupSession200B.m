function phTelegraphs_setupSession200B
	global state
	if state.analysisMode
		return
    end
	
    if ~isempty(state.phys.daq.telegraphSession)
        delete(state.phys.daq.telegraphSession);
        state.phys.daq.telegraphSession=[];
    end
    
    first=1;
    
	for channel=0:1	% add channels for main reading
        chanString=num2str(channel);
		if state.phys.settings.(['channelType' chanString])==2
            if first
                state.phys.daq.telegraphSession=daq.createSession('ni');
                first=0;
            end
            state.phys.daq.telegraphSession.addAnalogInputChannel(state.phys.daq.inputBoard, ...
                ['ai' num2str(state.phys.settings.(['gainTelegraph200B_Line' chanString]))], 'Voltage');
			state.phys.daq.telegraphSession.Channels(end).Range=[-10 10];

            state.phys.daq.telegraphSession.addAnalogInputChannel(state.phys.daq.inputBoard, ...
                ['ai' num2str(state.phys.settings.(['modeTelegraph200B_Line' chanString]))], 'Voltage');
			state.phys.daq.telegraphSession.Channels(end).Range=[-10 10];
		end
    end
	
    if ~first
        state.phys.daq.telegraphSession.Rate=10000;
        state.phys.daq.telegraphSession.DurationInSeconds=0.01;
    end
    
