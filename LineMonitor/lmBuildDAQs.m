function lmBuildDAQs

	global state lmSession

    if ~state.hasDevices
        return
    end

	counter=1;
	devList=[];
	activeList=[];
	adList=[];
	
	if state.lm.lineMonitorActive
        lmSession=daq.createSession('ni');
    end
    
    state.lm.activeLines=[];
    
	while isfield(state.lm, ['paramName' num2str(counter)])
		if (state.lm.(['active' num2str(counter)])==1) && ...
			(state.lm.(['dev' num2str(counter)])>0)
        
			devListNum=state.lm.(['dev' num2str(counter)]);
			devID=state.devices(devListNum).ID;
        
            aiChan=state.lm.(['ad' num2str(counter)]);

			seeGUI(['gh.lmSettings.paramName' num2str(counter)]);
			seeGUI(['gh.lmSettings.paramValue' num2str(counter)]);
            
            if state.lm.lineMonitorActive
               lmSession.addAnalogInputChannel(devID, ['ai' num2str(aiChan)], 'Voltage');
               lmSession.Channels(end).Range=[-10 10];
            end
            state.lm.activeLines(counter)=1;
        else
            state.lm.activeLines(counter)=0;
			hideGUI(['gh.lmSettings.paramName' num2str(counter)]);
			hideGUI(['gh.lmSettings.paramValue' num2str(counter)]);
			eval(['state.lm.paramValue' num2str(counter) '=NaN;']);
			updateGuiByGlobal(['state.lm.paramValue' num2str(counter)]);
		end
		counter=counter+1;
	end
	
		