function timerInit_Physiology
    global state gh

    
	if state.hasDevices
		h=waitbar(0,'Initializing Physiology');
	else
		h=waitbar(0,'Initializing Physiology in Analysis Mode');
	end	
	
	waitbar(.2,h);
	
    state.cycle.isCommonToAllPositions = ... 
        [state.cycle.isCommonToAllPositions ...
        'VCRCPulse' 'CCRCPulse' 'autoAnalyzeCC'];
	waveo('physAcqTrace', nan(1, 1000));
	waveo('physAcqTime0', nan(1, 1000));
	waveo('physAcqTime1', nan(1, 1000));	
	waveo('physCellRm0', nan(1, 1000));
	waveo('physCellRs0', nan(1, 1000));
	waveo('physCellCm0', nan(1, 1000));
	waveo('physCellVm0', nan(1, 1000));
	waveo('physCellIm0', nan(1, 1000));
	waveo('physCellRm1', nan(1, 1000));
	waveo('physCellRs1', nan(1, 1000));
	waveo('physCellCm1', nan(1, 1000));
	waveo('physCellVm1', nan(1, 1000));
	waveo('physCellIm1', nan(1, 1000));
		
	waitbar(.4,h);

    state.internal.guiOrderPhysiology=...
        {'physiologyOn', 'VCRCPulse', 'CCRCPulse', 'recordingDuration', ...
        'ao0', 'ao1', 'ao2', 'ao3', ...
        'do0', 'do1', 'do2', 'do3', ...
        'aux0', 'aux1', 'aux2', 'aux3', ...
        'aux4', 'aux5', 'aux6', 'aux7', ...
        };

    
	% initialize scope
	waveo('scopeInput0', 0, 'xscale', [0 1000/state.phys.scope.rate]);
	waveo('scopeInputFit0', [], 'xscale', [0 1000/state.phys.scope.rate]);
	waveo('scopeInput1', 0, 'xscale', [0 1000/state.phys.scope.rate]);
	waveo('scopeInputFit1', [], 'xscale', [0 1000/state.phys.scope.rate]);
	waveo('scopeFFT0', []);
	waveo('scopeFFT1', []);
    
    state.phys.cellParams.breakInClock0=clock;
	state.phys.cellParams.breakInClock1=clock;	
	state.phys.internal.channelGains=ones(1,32);

    global phAnalysis
    evalin('base', 'global phAnalysis');
    phAnalysis=[];
    
    global scopeInput0 scopeInputFit0 scopeInput1 scopeInputFit1
	
	plot(scopeInput0);
    
	state.phys.internal.scopeHandle=gcf;
	state.phys.internal.scopeAxisHandle=gca;

    append(scopeInput1);
	append(scopeInputFit0);
	append(scopeInputFit1);
    setPlotProps(scopeInputFit0, 'color', 'red', 'LineWidth', 2);
	setPlotProps(scopeInput0, 'LineWidth', 2);
    setPlotProps(scopeInputFit1, 'color', 'blue', 'LineWidth', 2);
	setPlotProps(scopeInput1, 'color', 'black', 'LineWidth', 2);
	
    set(state.phys.internal.scopeHandle, 'Name', 'SCOPE', ...
		'NumberTitle', 'off', ...
		'CloseRequestFcn', 'phScope_hide', ...
		'MenuBar', 'none');

    waitbar(.5,h);

	evalin('base', 'global physData physOutputData physOutputSession physInputSession');
	global physOutputSession physInputSession physData physOutputData
    physInputSession=[];
    physOutputSession=[];
    physData=[];
    physOutputData=[];
    
    state.phys.internal.needNewOutputChannels=1;
    state.phys.internal.needNewOutputData=1;
    
    phClamp_processSelection;
 	if state.hasDevices
        setPhysStatusString('Build Scope');
        phScope_makeSession;
        phScope_makeOutput;
   end

    waitbar(.6,h);

	state.cycle.physiologyOn=1;
	updateGuiByGlobal('state.cycle.physiologyOn');
	state.cycle.physiologyOnList(1)=1;
    
 	if state.hasDevices
        setPhysStatusString('Building DAQs');
        phSession_buildInput;
        phSession_buildOutput(2);
    else
		set(gh.physControls.startButton, 'Enable', 'off')
 		set(get(gh.scope.figure1, 'Children'), 'Enable', 'off');
 		phScope_hide;
 		set(get(gh.pulseMaker.figure1, 'Children'), 'Enable', 'off');
	end
    setPhysStatusString('');
	waitbar(1,h);
	close(h);
