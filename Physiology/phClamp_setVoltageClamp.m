function phClamp_setVoltageClamp(channel)
	global state

	eval(['state.phys.settings.currentClamp' num2str(channel) '=0;']);
	if any(state.phys.scope.channelsUsed==channel)
		state.phys.internal.needNewScopeOutput=1;
		state.phys.internal.scopeChannelChanged=1;
	end
	if getfield(state.cycle, ['pulseToUse' num2str(channel)])
		state.phys.internal.needNewOutputData=1;
	end
	updateGuiByGlobal(['state.phys.settings.currentClamp' num2str(channel)]);
	setPhysStatusString(['Channel ' num2str(channel) ' in V-Clamp']);