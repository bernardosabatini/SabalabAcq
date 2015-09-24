function timerStart_Physiology
	global state gh physOutputSession  physInputSession
	timerSetPackageStatus(1, 'Physiology');

	set(gh.physControls.liveModeButton, 'String', 'abort');
	
	if physInputSession.IsContinuous
		set(gh.physControls.startButton, 'String', 'end acq');
	else
		set(gh.physControls.startButton, 'String', 'ABORT');
	end
	set(gh.scope.start, 'Enable', 'off');
	setPhysStatusString('Running...');

    state.phys.internal.stripeCounter=1;
	state.phys.internal.stopInfiniteAcq=0;
    state.phys.internal.abort=0;
	
	phSetChannelGains

    if physInputSession.IsContinuous && state.phys.settings.streamToDisk && state.files.autoSave
        state.phys.internal.streamFID=[];
        state.phys.internal.streamFilename='';
        try
            state.phys.internal.streamFilename=phNames_streamingFile;
            [state.phys.internal.streamFID, ~]=...
                fopen(state.phys.internal.streamFilename, 'w');
         catch
            lasterr
        end
    end

    if ~isempty(state.phys.daq.auxOutputBoard)
        state.cycle.lastAuxPulsesUsed = [...
            state.cycle.aux4List(state.cycle.currentCyclePosition) ...
            state.cycle.aux5List(state.cycle.currentCyclePosition) ...
            state.cycle.aux6List(state.cycle.currentCyclePosition) ...
            state.cycle.aux7List(state.cycle.currentCyclePosition)];
    end

    state.files.lastAcquisition=state.files.fileCounter;

    % allocate memory
    global physData
    physData=zeros(...
        size(state.phys.internal.acquiredChannels,2), ...
        state.phys.internal.samplesPerStripe*state.phys.internal.stripes);

    % if there are output channels, queue data and start
    if ~isempty(physOutputSession.Channels)
        global physOutputData

        if physOutputSession.ScansQueued>0
            disp('timerStartPhysiology: Unexpectedly found queued data in physOutputSession.  Flushing...');
            physOutputSession.stop();
        end

        if physOutputSession.ScansQueued>0
            error('timerStartPhysiology: Flush failed');
        end

        physOutputSession.queueOutputData(physOutputData);
        physOutputSession.startBackground();
    end

    % if are not the master, then start and wait for trigger
    if ~state.phys.internal.triggerSetToMaster
        physInputSession.startBackground();
    end
	
	state.phys.internal.forceTrigger=0;


