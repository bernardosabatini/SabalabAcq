function initTimer(packages)

	global state gh
    
    if nargin<1
        packages=[];
    end
    
    %get the basics of the timer windows open
    state.initializing=1;
	gh.timerMainControls = guihandles(timerMainControls); % Opens Main Controls GUI window
	gh.pulseMaker=guihandles(pulseMaker);
	set(gh.timerMainControls.statusString, 'String', 'Opening GUIS...')
    gh.advancedCycleGui=guihandles(advancedCycleGui);
    set(gh.timerMainControls.statusString, 'String', 'Read timer.ini ...')
    initGUIs('timer.ini');
    initGUIs('timer_machineSpecific.ini'); % introduces packagesPath to state.timer struct.
    
    state.cycle.isCommonToAllPositions={'randomize' ...
        'holdDAQUpdates'...
        'writeProtect'...
        'useCyclePos'...
        'endAfterCycle'...
        };
		cycle.randomize=state.cycle.randomize;		
		cycle.writeProtect=state.cycle.writeProtect;		
		cycle.useCyclePos=state.cycle.useCyclePos;		    
    
    makeTimerPackagesMenu;  % Build Packages Menu in Main Controls ans state.timer struct.
    
    initNotebooks; % Init. Notebook GUI

    timerSetActiveStatus(packages, 1, 1); 
    % Set active packages to state.timer.activePackages & menu
    % First 1 indicates status
    % Second 1 skips call to timePACKAGENAME_Init
    % this call will happend manually below after user settings are loaded

%     timerCallPackageFunctions('MergeCycleGui'); % Stack GUI windows 
    % each package makes it's own cycle window. 
    % this package function will, if desired, add the window parameters to
    % the main cycle window
    
    %   call package InitGUIs
%     timerCallPackageFunctions('InitGUI');  
    % Each package should initialize its GUIs and fill with some default
    % values.  However, the real initialization is not done until later to
    % prevent making and deleting DAQ engines multiple times
    % 

    %% 
	set(gh.timerMainControls.statusString, 'String', 'Read machineSpecific.ini ...')
	initGUIs('machineSpecific.ini');
	setStatusString('Opening packages...');

	state.pulses.addCompList={''};
	state.pulses.patternNameList={''};
	waveo('currentPulsePattern', 0);
	waveo('currentPulseVectorX', [0 0]);
	waveo('currentPulseVectorY', [0 0]);
	changePulsePatternNumber(1);
    
	global currentPulsePattern
	plot(currentPulsePattern);
%	plotxy('currentPulseVectorX', 'currentPulseVectorY')
	state.internal.pulsePatternPlot=gcf;
	set(state.internal.pulsePatternPlot, 'visible', 'off', ...
		'CloseRequestFcn', 'hideCurrentWindow', ...
		'Name', 'PULSE PATTERN', ...
 		'NumberTitle', 'off', ...
 		'Position', [400   656   321   144], ...
 		'MenuBar', 'none');
	
	state.internal.guiOrder={'repeats', 'delay', 'functionName'};
    
    state.internal.startupTime=clock;
	state.internal.startupTimeString=clockToString(state.internal.startupTime);
	updateHeaderString('state.internal.startupTimeString');

	state.internal.cycleListNames={};
	allfields=fieldnames(state.cycle);
	for counter=1:length(allfields)
		if ~isempty(findstr(allfields{counter}, 'List'))
			tag=allfields{counter};
			state.internal.cycleListNames{end+1}=tag(1:end-4);
		end
	end
	
	state.internal.triggerTime=clock;
	
    timerCallPackageFunctions('Init');

	initTraceAnalysis; % 8) initi Analysis GUI
    
	loadUserSettingsPath;
	loadUserSettings;
	timerCycle_setDisplayPosition(1);
    if ~isempty(state.timer.analysisFunctionPath) && ...
            ischar(state.timer.analysisFunctionPath)
    	timerMakeAnalysisFunctionMenu;
    end
	
	if ~state.hasDevices
		set(gh.timerMainControls.loop, 'Enable', 'off');
		set(gh.timerMainControls.doOne, 'Enable', 'off');
		state.files.autoSave=0;
		updateGuiByGlobal('state.files.autoSave');
    end

    timerMakeAnalysisFunctionMenu
	
	waveo('timerAcqTime', []);
	setStatusString('Ready to Use');
    
    state.initializing=0;
    %try
    %    TNSetPath;
    %catch
    %end
