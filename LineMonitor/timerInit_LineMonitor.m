function timerInit_LineMonitor
	global  gh
	
	gh.lmSettings=guihandles(lmSettings);
	initGUIs('linemonitor.ini');
    
    evalin('base', 'global lmSession')
    global lmSession
    lmSession=[];
    
	lmMakeDeviceIDList
	lmBuildDAQs
	lmReadDAQs