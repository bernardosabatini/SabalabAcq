function phSession_endAcquisitionProcessing
	global state

	global physData
	for counter=1:size(state.phys.acquisitionFiles,2)
        validCurrentClamp=0;
        validVoltageClamp=0;
		channel=state.phys.acquisitionFiles{1,counter};			% what DA #
        chanString=num2str(channel);
		if (channel==0) || (channel==1)				% do series resistance processing for 1st 2 channels
			if state.phys.settings.(['channelType' chanString])>1		% if channel is a clamp
				% if channel is in V-clamp and a RS check pulse is selected
				if ~state.phys.settings.(['currentClamp' chanString])	
                    validVoltageClamp=1;
                    if state.cycle.VCRCPulse
                        % voltage clamp calculation of passive parameters
                        [rin, rs, cm, calcRsError]=calcRs(physData(counter,:), ...		% data
                            1000/state.phys.settings.inputRate, ...									% dx
                            state.pulses.amplitudeList(state.cycle.VCRCPulse), ...		% amp
                            state.pulses.delayList(state.cycle.VCRCPulse), ...			% pulse start
                            state.pulses.pulseWidthList(state.cycle.VCRCPulse), ...		% pulse width
                            max(state.pulses.delayList(state.cycle.VCRCPulse)-50, 1),...	% baseline start
                            0.99*state.pulses.delayList(state.cycle.VCRCPulse));		% baseline end
                        if calcRsError
                            disp('processPhysData: calcRs returned an error');
                        end
                        state.phys.cellParams.(['rm' chanString])=round(10*rin)/10;
                        state.phys.cellParams.(['rs' chanString])=round(10*rs)/10;
                        state.phys.cellParams.(['cm' chanString])=round(10*cm)/10;
                    end
                elseif state.phys.settings.(['currentClamp' chanString])
                    validCurrentClamp=1;
                    if state.cycle.CCRCPulse
                        % current clamp check of Rin
                        dx=1000/state.phys.settings.inputRate;
                        baselineV=mean(physData(counter, ...
                            max(round((state.pulses.delayList(state.cycle.CCRCPulse)-50)/dx), 1) ...
                            : ...
                            round((state.pulses.delayList(state.cycle.CCRCPulse)-1)/dx)...
                            ));
                        peakV=mean(physData(counter, ...
                            round((state.pulses.delayList(state.cycle.CCRCPulse)+0.8*state.pulses.pulseWidthList(state.cycle.CCRCPulse))/dx) ...
                            : ...
                            round((state.pulses.delayList(state.cycle.CCRCPulse)+state.pulses.pulseWidthList(state.cycle.CCRCPulse))/dx-1)...
                            ));
                        rin=1000*(peakV-baselineV)/state.pulses.amplitudeList(state.cycle.CCRCPulse);
                        state.phys.cellParams.(['rm' chanString])=round(10*rin)/10;
                        state.phys.cellParams.(['rs' chanString])=NaN;
                        state.phys.cellParams.(['cm' chanString])=NaN;
                    else
                        state.phys.cellParams.(['rm' chanString])=NaN;
                        state.phys.cellParams.(['rs' chanString])=NaN;
                        state.phys.cellParams.(['cm' chanString])=NaN;
                    end
                end
                
				updateGuiByGlobal(['state.phys.cellParams.rm' chanString]);
				updateGuiByGlobal(['state.phys.cellParams.rs' chanString]);
				updateGuiByGlobal(['state.phys.cellParams.cm' chanString]);
			end
		end

		% store the data in a wave that contains the acq #
		name=physTraceName(channel, state.files.lastAcquisition);
		state.phys.acquisitionFiles{3, counter}=name;

		waveo(name, physData(counter,:), ...
			'xscale', [0 1000/state.phys.settings.inputRate]);
		setWaveUserDataField(name, 'headerString', state.headerString);
        setWaveUserDataField(name, 'ai', state.phys.acquisitionFiles{1, counter});

        % do automatic current clamp analysis?
        if validCurrentClamp && state.cycle.autoAnalyzeCC
            phAnalyze_CurrentClamp(name);
        end
        
		% auto save to disk?

		eval(['global ' name]);

		if state.files.autoSave
			save(fullfile(state.files.savePath, name), name);
		end

		% online averaging?
        if state.phys.settings.(['avg' chanString])
            if state.cycle.useCyclePos
                avgName=physAvgName(state.epoch, channel, state.cycle.lastPositionUsed);
            else
                avgName=physAvgName(state.epoch, channel, state.phys.internal.lastPulsesUsed(1));
            end
            
            avgin(name, avgName);
            state.phys.acquisitionFiles{4, counter}=avgName;
            
            if state.files.autoSave
                eval(['global ' avgName]);
                save(fullfile(state.files.savePath, avgName), avgName);
            end
        end

	end

	% Make a note in the auto notebook and save it
	addEntryToNotebook(2, ...
		[datestr(clock,13) ' (' num2str(state.phys.cellParams.minInCell0) ' min): Acq # ' num2str(state.files.lastAcquisition) ...
		' CycPos ' num2str(state.cycle.currentCyclePosition) ' Repeat ' num2str(state.cycle.repeatsDone) ...
		' Patterns ' num2str(state.phys.internal.lastPulsesUsed)]);


