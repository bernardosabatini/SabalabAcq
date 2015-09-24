function timerTrigger_Physiology
    global state
    
    if ~state.phys.internal.triggerSetToMaster
        error('timerTrigger_Physiology: called on to trigger, but we are not the master');
    else
        global physInputSession
        physInputSession.startBackground();
    end