function phSession_setNumberOfInputScans
    global state physOutputData physInputSession

    if state.phys.internal.runningMode==1
        numberOfInputSamples=Inf;
    else
        if state.cycle.inputTracksOutputList(state.cycle.currentCyclePosition)==1
            if isempty(physOutputData)
                disp('*** WARNING: Input duration tracks output is enable but no output is selected ***')
                disp('***          Input duration set to 1 second default ***')
                numberOfInputSamples=round(state.phys.settings.inputRate/state.phys.internal.stripes)*state.phys.internal.stripes;
            else
                numberOfInputSamples=round((size(physOutputData,1)*state.phys.settings.inputRate/state.phys.settings.outputRate)/state.phys.internal.stripes)*state.phys.internal.stripes;
            end
            state.phys.internal.samplesPerStripe=numberOfInputSamples/state.phys.internal.stripes;
        else
            if (state.cycle.recordingDurationList(state.cycle.currentCyclePosition)==0)
                if isempty(physOutputData)
                    disp('*** WARNING: No input duration given. Set to 1 second default ***')
                    numberOfInputSamples=...
                        round(state.phys.settings.inputRate/state.phys.internal.stripes)...
                        *state.phys.internal.stripes;
                else
                    numberOfInputSamples=...
                        round((size(physOutputData,1)*state.phys.settings.inputRate/state.phys.settings.outputRate)/state.phys.internal.stripes)*state.phys.internal.stripes;
                end
                state.phys.internal.samplesPerStripe=numberOfInputSamples/state.phys.internal.stripes;
            elseif state.cycle.recordingDurationList(state.cycle.currentCyclePosition)==Inf
                numberOfInputSamples=Inf;
                state.phys.internal.samplesPerStripe...
                    = round((state.phys.settings.runViewSliceDuration*state.phys.settings.inputRate)/state.phys.internal.stripes);
            else
                numberOfInputSamples=...
                    round(...
                    (state.cycle.recordingDurationList(state.cycle.currentCyclePosition)*state.phys.settings.inputRate)...
                    /state.phys.internal.stripes)*state.phys.internal.stripes;
                state.phys.internal.samplesPerStripe=numberOfInputSamples/state.phys.internal.stripes;
            end
        end
    end

    if numberOfInputSamples==Inf
        physInputSession.IsContinuous=1;
        state.phys.internal.samplesPerStripe=round(...
            state.phys.settings.runViewSliceDuration*physInputSession.Rate...
            /state.phys.internal.stripes);
    else
        physInputSession.IsContinuous=0;
        state.phys.internal.samplesPerStripe=round(numberOfInputSamples/state.phys.internal.stripes);
        physInputSession.NumberOfScans=state.phys.internal.samplesPerStripe*state.phys.internal.stripes;
    end
    physInputSession.NotifyWhenDataAvailableExceeds=state.phys.internal.samplesPerStripe;
    