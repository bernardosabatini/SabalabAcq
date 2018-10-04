function phClamp_setCurrentClamp(channel)
	global state
	
	eval(['state.phys.settings.currentClamp' num2str(channel) '=1;']);
	if any(state.phys.scope.channelsUsed==channel)
		state.phys.internal.needNewScopeOutput=1;
		state.phys.internal.scopeChannelChanged=1;
	end
	state.phys.internal.needNewOutputData=1;

    updateGuiByGlobal(['state.phys.settings.currentClamp' num2str(channel)]);
	setPhysStatusString(['Channel ' num2str(channel) ' in C-Clamp']);
	
