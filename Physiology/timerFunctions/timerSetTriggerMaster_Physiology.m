function timerSetTriggerMaster_Physiology
    global state physInputSession physOutputSession

    madeChanges=...
        timerSession_ensureTriggerConnections(physInputSession, 1, state.timer.triggerLine);
    
    madeChanges=...
        timerSession_ensureTriggerConnections(physOutputSession, 0, state.timer.triggerLine);

    if madeChanges
        state.phys.internal.needNewOutputChannels=1;
        state.phys.internal.needNewOutputData=1;
    end

    state.phys.internal.triggerSetToMaster=1;
        