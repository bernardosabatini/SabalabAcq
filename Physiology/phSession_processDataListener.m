function phSession_processDataListener(session, event)
 	global state physInputSession
    
    
    if state.phys.internal.stopInfiniteAcq
 		session.stop();
 		setPhysStatusString('Proccesing...');
 	end
    
	if state.phys.internal.stripeCounter==1
		% record the trigger time
        state.phys.internal.triggerClock=datestr(event.TriggerTime);
        state.phys.internal.triggerTime=event.TriggerTime;

		state.phys.acquisitionFiles=cell(4, length(state.phys.internal.acquiredChannels));
		% this cell structure will save information about the waves of each
		% channel as follows:
		%	state.phys.acquisitionFiles{1, :} will have the AD channel #
		%	state.phys.acquisitionFiles{2, :} will have the name of the
		%		display wave (e.g. dataWave0)
		%	state.phys.acquisitionFiles{3, :} will have the name of the
		%		acquisition wave (e.g. AD0_9)
		%	state.phys.acquisitionFiles{4, :} will have the name of the
		%		average wave (e.g. AD0_e1p1avg)
	end

	% At this point, we got the event.Data and recorded the trigger time.

	% Below, put it in event.Data waves, calculate Rs if appropriate, store headerString,
	% save, average, and, if desired, kill

	startData=state.phys.internal.samplesPerStripe*(state.phys.internal.stripeCounter-1)+1;
	endData=state.phys.internal.samplesPerStripe*state.phys.internal.stripeCounter;

	global physData
	for counter=1:length(state.phys.internal.acquiredChannels)
		channel=state.phys.internal.acquiredChannels(counter);			% what DA #

		physData(counter, startData:endData)=...
			state.phys.internal.channelGains(channel+1)*event.Data(:,counter)';

		if state.phys.internal.stripeCounter==1
			state.phys.acquisitionFiles{1, counter}=channel;
			state.phys.acquisitionFiles{2, counter}=['dataWave' num2str(channel)];
			if ~iswave(['dataWave' num2str(channel)])
				waveo(['dataWave' num2str(channel)], physData(counter), ...
					'xscale', [0 1000/physInputSession.Rate]);
			else
				setWave(['dataWave' num2str(channel)], 'xscale', [0 1000/physInputSession.Rate]);
				eval(['global dataWave' num2str(channel)]);
				eval(['dataWave' num2str(channel) '(startData:endData)=physData(counter, startData:endData);']);
			end

			setfield(['dataWave' num2str(channel)], 'headerString', state.headerString);
        end
        
 		if (state.phys.internal.stripeCounter==state.phys.internal.stripes)
			setWave(['dataWave' num2str(channel)], 'data', physData(counter,:))
		else
			eval(['global dataWave' num2str(channel)]);
			eval(['dataWave' num2str(channel) '(startData:endData)=physData(counter, startData:endData);']);
		end

		% this adds a small leading blank as the event.Data appears on the screen
		if state.phys.internal.stripeCounter<state.phys.internal.stripes
			eval(['dataWave' num2str(channel) '(endData+1:round(endData+state.phys.internal.samplesPerStripe/2))=NaN;']);
		end
    end
    
  	if (state.phys.internal.stripeCounter==state.phys.internal.stripes) || state.phys.internal.stopInfiniteAcq % last one, process everything
 		if physInputSession.IsContinuous 
            if state.phys.internal.stopInfiniteAcq
                 if state.files.autoSave && state.phys.settings.streamToDisk && state.phys.settings.reloadContAcq
                    % we were in infinite mode.  We need to reload event.Data from the
                    % drive
                    if ~isempty(state.phys.internal.streamFID)
                        fclose(state.phys.internal.streamFID);
                        phStreaming_readFile(state.phys.internal.streamFilename);
                    else
                        disp('ERROR: Why is the live stream FID closed?');
                    end
                end
            else
                % we are in the live mode and continuing. 
                % write the data
                if state.phys.settings.streamToDisk && state.files.autoSave
                    fwrite(state.phys.internal.streamFID, physData, 'float');
                end
                
                %reset the stripe counter
                state.phys.internal.stripeCounter=1;
                return
            end
 		end
 		
 		phSession_endAcquisitionProcessing
        
   		if physInputSession.IsContinuous 
%             global physOutputSession
%             physInputSession.release();
%             physOutputSession.release();
            timerRegisterPackageDone('Physiology');       
        end
 	else
 		state.phys.internal.stripeCounter=state.phys.internal.stripeCounter+1;
 		if physInputSession.IsContinuous
 			setPhysStatusString('Infinite acq');
 		end
 	end
% 
% 
