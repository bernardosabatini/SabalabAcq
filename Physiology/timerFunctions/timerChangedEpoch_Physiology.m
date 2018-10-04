function timerChangedEpoch_Physiology
    global state phAnalysis
    
    if ~state.internal.epochsUsed(state.epoch)
        phAnalysis.(['e' num2str(state.epoch)])=[];
    end
        
