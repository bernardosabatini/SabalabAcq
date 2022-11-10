function timerCycle_updateMaxCyclePos
    global state
    
    state.internal.maxCyclePos=['/' num2str(length(state.cycle.delayList))];
    updateGuiByGlobal('state.internal.maxCyclePos');
