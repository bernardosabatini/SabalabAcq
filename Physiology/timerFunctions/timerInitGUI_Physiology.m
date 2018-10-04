function timerInitGUI_Physiology
   	global gh
    
	gh.physControls=guihandles(physControls);
	gh.physSettings=guihandles(physSettings);
	gh.scope=guihandles(scope);
	
	openini('physiology.ini');
	

	