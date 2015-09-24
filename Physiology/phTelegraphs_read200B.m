function phTelegraphs_read200B
	global state
    
	telegraphs=mean(state.phys.daq.telegraphSession.startForeground());
%    telegraphs=state.phys.daq.telegraphSession.inputSingleScan();
	state.phys.daq.telegraphSession.release;    

	pos=1;
	for channel=0:1
        % is it an axon 200b?
        if getfield(state.phys.settings, ['channelType' num2str(channel)])==2
			sChannel=num2str(channel);

            index=round(2*telegraphs(pos));
            if index<1
                disp(['*** phTelegraphs_read200B unable to read channel' sChannel ' gain']);
                disp(['    setting to 1']);
                state.phys.settings.(['inputGain' sChannel])=1;
            else
                state.phys.settings.(['inputGain' sChannel])=...
                    state.phys.settings.gainList_200B(index);
            end
            updateGuiByGlobal(['state.phys.settings.inputGain' num2str(channel)]);
				
            if round(telegraphs(pos+1))>=4 	% we are in VC mode
                if getfield(state.phys.settings, ['currentClamp' num2str(channel)])	% but we were in CC mode
                    phClamp_setVoltageClamp(channel);
                end
            else		% we are in CC mode
                if ~getfield(state.phys.settings, ['currentClamp' num2str(channel)]) % but we were in VC mode
                    phClamp_setCurrentClamp(channel);
                end
                pos=pos+2;
            end
        end 
    end
       
	state.phys.daq.telegraphSession.release;    
    