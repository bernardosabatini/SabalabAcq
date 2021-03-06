function phSession_buildInput

	global state physInputSession

    delete(physInputSession);
    
    physInputSession = daq.createSession('ni');
    physInputSession.Rate=state.phys.settings.inputRate;

	state.phys.internal.acquiredChannels=[];
	for channel=0:7
		if state.phys.settings.(['acq' num2str(channel)])
            physInputSession.addAnalogInputChannel(...
                state.phys.daq.inputBoard, ...
                ['ai' num2str(channel)],...
                'Voltage'...
                );
            physInputSession.Channels(end).Range=[-10 10];
		state.phys.internal.acquiredChannels(end+1)=channel;
        end
    end
    
    if isempty(state.phys.internal.acquiredChannels)
        error('No acquisition channels selected');
    end
    
    addTriggerConnection(physInputSession, ...
        [state.phys.daq.inputBoard '/' state.phys.daq.inputExportTriggerLine], ...
        'external', ...
        'StartTrigger');
%    addClockConnection(physInputSession, ...
%         [state.phys.daq.inputBoard '/RTSI2'], ...
%         'external', ...
%         'ScanClock')   
    physInputSession.addlistener('DataAvailable', @phSession_processDataListener);
    



   	