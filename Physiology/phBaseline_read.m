function phBaseline_read
	global state

% 	data=state.phys.daq.baselineSession.startForeground();		
% 	baseline=mean(data);
	
 	baseline=state.phys.daq.baselineSession.inputSingleScan();
    state.phys.daq.baselineSession.release();
    
	pos=0;
	for counter=0:1
		type=getfield(state.phys.settings, ['channelType' num2str(counter)]);
		if type > 1
			scounter=num2str(counter);
            ind=1+pos*2;
			if eval(['state.phys.settings.currentClamp' scounter])
				eval(['state.phys.cellParams.vm' scounter '=round(10*baseline(ind)*state.phys.internal.channelGains(ind))/10;']);
				eval(['state.phys.cellParams.im' scounter '=round(10*baseline(ind+1)*state.phys.internal.channelGains(ind+2))/10;']);
            else
				eval(['state.phys.cellParams.im' scounter '=round(10*baseline(ind)*state.phys.internal.channelGains(ind))/10;']);
				eval(['state.phys.cellParams.vm' scounter '=round(10*baseline(ind+1)*state.phys.internal.channelGains(ind+2))/10;']);
			end
			pos=pos+1;
			updateGuiByGlobal(['state.phys.cellParams.vm' scounter]);
			updateGuiByGlobal(['state.phys.cellParams.im' scounter]);
		end
	end
	state.phys.daq.baselineSession.release;

	