function timerProcess_Physiology
% timer package process function for physiology
% most of the processing is actually done by the listener function
	global state gh
	
	% put acq # and acq times in waves
	global physAcqTrace physAcqTime  
	physAcqTrace(state.files.lastAcquisition)=state.files.lastAcquisition;
	physAcqTime(state.files.lastAcquisition)=state.phys.cellParams.minInCell0;

	if state.files.autoSave && state.phys.settings.autosavePassiveParam 
		save(fullfile(state.files.savePath, 'physAcqTrace'), 'physAcqTrace');
		save(fullfile(state.files.savePath, 'physAcqTime'), 'physAcqTime');
    end

    
    global timerAcqTime

    if ~iswave('timerAcqTime')
        wave('timerAcqTime', []);
    end
    
	for counter=0:1
		if state.phys.settings.(['channelType' num2str(counter)])>=2 % it's a clamp
			eval(['global physCellVm' num2str(counter)]);		
			eval(['physCellVm' num2str(counter) '(state.files.lastAcquisition)=state.phys.cellParams.vm' num2str(counter) ';' ] );
			eval(['global physCellIm' num2str(counter)]);		
			eval(['physCellIm' num2str(counter) '(state.files.lastAcquisition)=state.phys.cellParams.im' num2str(counter) ';' ]);
			eval(['global physCellRm' num2str(counter)]);		
			eval(['physCellRm' num2str(counter) '(state.files.lastAcquisition)=state.phys.cellParams.rm' num2str(counter) ';' ]);
			eval(['global physCellRs' num2str(counter)]);
 			eval(['physCellRs' num2str(counter) '(state.files.lastAcquisition)=state.phys.cellParams.rs' num2str(counter) ';' ]);
			eval(['global physCellCm' num2str(counter)]);
			eval(['physCellCm' num2str(counter) '(state.files.lastAcquisition)=state.phys.cellParams.cm' num2str(counter) ';' ]);
		
			if state.files.autoSave && state.phys.settings.autosavePassiveParam 
				save(fullfile(state.files.savePath, ['physCellVm' num2str(counter)]), ['physCellVm' num2str(counter)]);
				save(fullfile(state.files.savePath, ['physCellIm' num2str(counter)]), ['physCellIm' num2str(counter)]);
				save(fullfile(state.files.savePath, ['physCellCm' num2str(counter)]), ['physCellCm' num2str(counter)]);
				save(fullfile(state.files.savePath, ['physCellRs' num2str(counter)]), ['physCellRs' num2str(counter)]);
				save(fullfile(state.files.savePath, ['physCellRm' num2str(counter)]), ['physCellRm' num2str(counter)]);
			end
		end
	end	
	
	if (~isempty(state.internal.excelChannel)) && state.files.autoSave
		try
			r=['r' num2str(25 + state.files.lastAcquisition)];
			ddepoke(state.internal.excelChannel, [r 'c30:' r 'c31'], [state.files.lastAcquisition state.epoch]);
			ddepoke(state.internal.excelChannel, [r 'c32'], state.pulses.pulseSetName);
			ddepoke(state.internal.excelChannel, [r 'c33:' r 'c50'], [...
					state.phys.internal.pulseUsed0 ...
					state.phys.internal.pulseUsed1 ...
					state.phys.settings.extraGain0 ...
					state.phys.settings.extraGain1...
					state.phys.cellParams.minInCell0 ...
					state.phys.settings.currentClamp0 ...
					state.phys.cellParams.vm0 ...
					state.phys.cellParams.im0 ...
					state.phys.cellParams.rm0 ...
					state.phys.cellParams.rs0 ...
					state.phys.cellParams.cm0 ...
					state.phys.cellParams.minInCell1 ...
					state.phys.settings.currentClamp1 ...
					state.phys.cellParams.vm1 ...
					state.phys.cellParams.im1 ...
					state.phys.cellParams.rm1 ...
					state.phys.cellParams.rs1 ...
					state.phys.cellParams.cm1 ...
				]);
		catch
			disp('timerProcess_Physiology : unable to link to excel');
		end
    end

	try
		if 0 && state.analysis.active
			runTraceAnalyzer(1);
		end
	catch
		disp(['timerProcess_Physiology : ' lasterr]);
		disp('	when doing trace analysis');
    end
    
    set(gh.scope.start, 'Enable', 'on');
	setPhysStatusString('');

 	% are they keeping data or killing it?
 	if ~state.phys.settings.keepInMemory
		for counter=1:length(state.phys.internal.newWaves)
			kill(state.phys.internal.newWaves{counter});
		end
	end		

	if ~state.cycle.loopingStatus
		set(gh.physControls.startButton, 'String', 'GRAB');
		set(gh.physControls.liveModeButton, 'String', 'live');
		set([gh.physControls.startButton gh.scope.start], 'Enable', 'on');
	else
		set(gh.scope.start, 'Enable', 'on');
	end		
	
    try
        if state.db.conn~=0
            for counter=1:length(state.db.phys.wave_ids)
                state.db.phys.wave_id=state.db.phys.wave_ids(counter);
                state.db.phys.channel=state.db.phys.channels(counter);
                eval(['state.db.phys.currentClamp=state.phys.settings.currentClamp' num2str(counter) ';']);
                eval(['state.db.phys.inputGain=state.phys.settings.inputGain' num2str(counter) ';']);
                addRecordByTable('PhysAcq');
            end
            state.db.phys.wave_ids=[];
            state.db.phys.channels=[];
        end
    catch
    end