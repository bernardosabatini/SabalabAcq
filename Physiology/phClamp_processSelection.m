function phClamp_processSelection(channelList)
	global state
	
    if nargin<1
        channelList=[0 1];
    end
    
	for channel=channelList
		switch state.phys.settings.(['channelType' num2str(channel)])
		case 1     
			eval(['state.phys.settings.mVPerVIn' num2str(channel) '=1;']);
			eval(['state.phys.settings.mVPerVOut' num2str(channel) '=1;']);
			eval(['state.phys.settings.pAPerVIn' num2str(channel) '=1;']);
			eval(['state.phys.settings.pAPerVOut' num2str(channel) '=1;']);
		case 2  % axon
			eval(['state.phys.settings.mVPerVIn' num2str(channel) '=state.phys.settings.axoPatchMVPerVIn;']);
			eval(['state.phys.settings.mVPerVOut' num2str(channel) '=state.phys.settings.axoPatchMVPerVOut;']);
			eval(['state.phys.settings.pAPerVIn' num2str(channel) '=state.phys.settings.axoPatchPAPerVIn;']);
			eval(['state.phys.settings.pAPerVOut' num2str(channel) '=state.phys.settings.axoPatchPAPerVOut;']);
			phTelegraphs_setupSession200B;
		case 3 % multiclamp
			eval(['state.phys.settings.mVPerVIn' num2str(channel) '=state.phys.settings.multiClampMVPerVIn;']);
			eval(['state.phys.settings.mVPerVOut' num2str(channel) '= state.phys.settings.multiClampMVPerVOut;']);
			eval(['state.phys.settings.pAPerVIn' num2str(channel) '=state.phys.settings.multiClampPAPerVIn;']);
			eval(['state.phys.settings.pAPerVOut' num2str(channel) '= state.phys.settings.multiClampPAPerVOut;']);
		end
		
		updateGuiByGlobal(['state.phys.settings.mVPerVIn' num2str(channel)]);		
		updateGuiByGlobal(['state.phys.settings.mVPerVOut' num2str(channel)]);
		updateGuiByGlobal(['state.phys.settings.pAPerVIn' num2str(channel)]);
		updateGuiByGlobal(['state.phys.settings.pAPerVOut' num2str(channel)]);
    end
    
    phBaseline_setupSession