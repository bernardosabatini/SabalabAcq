function lmMakeDeviceIDList
	global state gh
		
    if ~state.hasDevices
        return
    end
    
	counter=1;
	while isfield(state.lm, ['paramName' num2str(counter)])
		h=gh.lmSettings.(['dev' num2str(counter)]);
		if ishandle(h)
			set(h, 'String', state.deviceIDs);
			if get(h, 'Value')>length(state.deviceIDs)
				eval(['gh.lmSettings.dev' num2str(counter) '=1;']);
				updateGuiByGlobal(['gh.lmSettings.dev' num2str(counter)]);
			end
		end
		counter=counter+1;
	end