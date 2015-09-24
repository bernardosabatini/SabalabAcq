function timerUserSettings_LineMonitor
    global state
    if ~isempty(state.lm.currentSettingsFile)
        lmLoadSettings(state.lm.currentSettingsFile);
    else
    	lmMakeDeviceIDList
        lmBuildDAQs
    end