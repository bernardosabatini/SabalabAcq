function timerSetTriggerSlave_Physiology
    global state physInputSession physOutputSession

%     if strcmp(state.timer.triggerPackage, 'Physiology')
%         error('timerSetTriggerSlave_Physiology: Asking to be slave when timer says we are the master');
%     end
    
    madeChanges=...
        timerSession_ensureTriggerConnections(physInputSession, 0, state.timer.triggerLine);
    
    madeChanges=...
        timerSession_ensureTriggerConnections(physOutputSession, 0, state.timer.triggerLine);

    if madeChanges
        state.phys.internal.needNewOutputChannels=1;
        state.phys.internal.needNewOutputData=1;
    end
    
    state.phys.internal.triggerSetToMaster=0;
    
        