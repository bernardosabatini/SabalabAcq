function phScope_makeOutput
	global state 

    counter=1;
    state.phys.scope.CCUsed=state.phys.scope.channelsUsed;
    state.phys.scope.ampsUsed=state.phys.scope.channelsUsed;
    state.phys.scope.durationsUsed=state.phys.scope.channelsUsed;
    state.phys.scope.pointsUntilPulse=state.phys.scope.channelsUsed;
    state.phys.scope.gainToUse=state.phys.scope.channelsUsed;
    
    maxDuration=0;
    for channel=state.phys.scope.channelsUsed
        chanString=num2str(channel);
		if state.phys.settings.(['currentClamp' chanString])
            % we are in current clamp mode
            state.phys.scope.CCUsed(counter)=1;
            
			amp(counter)=state.phys.scope.pulseAmpCC/...
                state.phys.settings.(['pAPerVOut' chanString]);
            state.phys.scope.ampsUsed(counter)=state.phys.scope.pulseAmpCC;
			duration=state.phys.scope.pulseWidthCC;
            gain=state.phys.settings.(['mVPerVIn' chanString])...
                /state.phys.settings.(['inputGain' chanString]);
        else
            % not current clamp
             state.phys.scope.CCUsed(counter)=0;

            amp(counter)=state.phys.scope.pulseAmpVC/...
                state.phys.settings.(['mVPerVOut' chanString]);
            state.phys.scope.ampsUsed(counter)=state.phys.scope.pulseAmpVC;
			duration=state.phys.scope.pulseWidthVC;
            gain=state.phys.settings.(['pAPerVIn' chanString])...
                /state.phys.settings.(['inputGain' chanString]);
        end
        maxDuration=max(maxDuration, duration);
        state.phys.scope.durationsUsed(counter)=duration;
        state.phys.scope.pointsUntilPulse(counter)=round(duration*state.phys.scope.rate/2000);
        state.phys.scope.gainToUse(counter)=gain;
       
        setWave(['scopeInputFit' chanString], ...
            'xscale', [duration/2-1000/state.phys.scope.rate 1000/state.phys.scope.rate]);
        counter=counter+1;
    end
    nChans=length(state.phys.scope.channelsUsed);
	state.phys.scope.output=zeros(ceil(2*state.phys.scope.rate*maxDuration/1000),nChans);
    
  	for counter=1:nChans
        state.phys.scope.output(state.phys.scope.pointsUntilPulse(counter)...
            : 3*state.phys.scope.pointsUntilPulse(counter), counter) = amp(counter);
   end


	