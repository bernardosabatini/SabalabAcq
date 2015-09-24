function siSession_buildInput
	global state
	
	global focusInput grabInput
    
    if ~isempty(focusInput)
        delete(focusInput)
    end
    focusInput=daq.createSession('ni');
    focusInput.Rate=state.acq.inputRate;
 	actualInputRate =focusInput.Rate;	
    
    if ~isempty(grabInput)
        delete(grabInput)
    end
    grabInput=daq.createSession('ni');
    grabInput.Rate=state.acq.inputRate;
    
    onChannels=find(state.acq.acquiringChannel);
    state.internal.numberOfActiveChannels=length(onChannels);
	for channelCounter=onChannels
        ch=focusInput.addAnalogInputChannel(...
            state.imaging.daq.inputBoard, ...
            ['ai' num2str(channelCounter-1)],...
            'Voltage'...
            );
        ch.Range=[-10 10];

        ch=grabInput.addAnalogInputChannel(...
            state.imaging.daq.inputBoard, ...
            ['ai' num2str(channelCounter-1)],...
            'Voltage'...
            );
        ch.Range=[-10 10];
    end
	 
    focusInput.addlistener('DataAvailable', @siListener_focusStripe);
    focusInput.addTriggerConnection(...
         [state.imaging.daq.inputBoard '/RTSI0'], ...
         'external', ...
         'StartTrigger'...
         );    
     
    grabInput.addlistener('DataAvailable', @siListener_grabStripe);
    grabInput.addTriggerConnection(...
         [state.imaging.daq.inputBoard '/RTSI0'], ...
         'external', ...
         'StartTrigger'...
         );      
     
    siSet_acquisitionParameters
 	
 	% GRAB acquisition: set up action function trigger (1 per stripe)
    grabInput.NotifyWhenDataAvailableExceeds=state.internal.samplesPerStripe;
    siSet_grabSamples

 	% FOCUS acquisition: set up total acquisition duration
 	focusInput.NotifyWhenDataAvailableExceeds=state.internal.samplesPerStripe; 
 	focusInput.IsContinuous=1;
    
