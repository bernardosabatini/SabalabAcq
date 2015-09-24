function trig=timerTriggerLine_Physiology
    global state
    trig=[state.phys.daq.inputBoard '/' state.phys.daq.triggerOutputLine];