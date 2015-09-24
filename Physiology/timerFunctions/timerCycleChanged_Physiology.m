function timerCycleChanged_Physiology
	global gh state
%	disp(['timerCycleChanged_Physiology: the calling gui was ' state.cycle.callingTag]);
    
    if strcmp(state.cycle.callingTag, 'inputTracksOutput')
        if state.cycle.inputTracksOutput
            set(...
                [gh.advancedCycleGui.recordingDuration]...
                , 'Enable', 'off')
        else
            set(...
                [gh.advancedCycleGui.recordingDuration]...
                , 'Enable', 'on')
        end
    end

    
    % did the user modify the cycle position that is about to be executed?
    if state.cycle.displayCyclePosition==state.cycle.currentCyclePosition 
        switch state.cycle.callingTag
            case 'physiologyOn'
                timerSetActiveStatus('Physiology', state.cycle.physiologyOn);
            case {'da0', 'da1'} 
                state.phys.internal.needNewOutputData=1;
                chan=str2num(state.cycle.callingTag(3:end));
                % if channel is on put was off, remake output device
                if state.cycle.(state.cycle.callingTag)>0
                    if ~any(state.phys.internal.outputChannelsUsed==chan)
                        state.phys.internal.needNewOutputChannels=1;
                    end
                % if channels is off but was on, remake output device
                else
                    if any(state.phys.internal.outputChannelsUsed==chan)
                        state.phys.internal.needNewOutputChannels=1;
                    end
                end
                    
            case {'aux4', 'aux5', 'aux6', 'aux7'} 
                state.phys.internal.needNewOutputData=1;
                chan=str2num(state.cycle.callingTag(4:end));
                % if channel is on put was off, remake output device
                if state.cycle.(state.cycle.callingTag)>0
                    if ~any(state.phys.internal.auxOutputChannelsUsed==chan)
                        state.phys.internal.needNewOutputChannels=1;
                    end
                % if channels is off but was on, remake output device
                else
                    if any(state.phys.internal.auxOutputChannelsUsed==chan)
                        state.phys.internal.needNewOutputChannels=1;
                    end
                end
        end
    end
