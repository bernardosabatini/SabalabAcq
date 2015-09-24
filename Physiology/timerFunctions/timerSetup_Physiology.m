function timerSetup_Physiology
	global state

	state.phys.internal.abort=0;
	
	updateMinInCell;

    phSession_buildOutput;
    phSession_makeOutput;
    phSession_setNumberOfInputScans;
    
    
    