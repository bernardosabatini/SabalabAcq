function phSession_buildOutput(force)
	if nargin<1
		force=0;
    end

%    disp('phSession_buildOutput CALLED')
	
    global state physOutputSession gh

    if state.phys.internal.runningMode
        return
    end
    
    if ~state.phys.internal.needNewOutputChannels && ~force
        return
    end
    set(gh.advancedCycleGui.physiologyPanel, 'visible', 'off')
    setPhysStatusString('BUILDING DEVICE')
    
    
 %   disp('phSession_buildOutput EXECUTING')
    
    state.phys.internal.needNewOutputData=1;
    if (force==2) || isempty(physOutputSession)
        delete(physOutputSession);
        physOutputSession = daq.createSession('ni');
    else
        nC=length(physOutputSession.Channels);
        if (nC>0)
            removeChannel(physOutputSession, 1:nC);
        end
    end
    
    physOutputSession.Rate=state.phys.settings.outputRate;

    state.phys.internal.outputChannelsUsed=[];
    state.phys.internal.auxOutputChannelsUsed=[];
    
    hasMainOutput=0;
        
    state.phys.internal.lastLinesUsed={};
    state.phys.internal.lastPulsesUsed=[];
    
    for channel=0:state.phys.daq.numOutputChannels-1
        chanString=num2str(channel);
        chanName=['ao' chanString];
        outPulse=state.cycle.([chanName 'List'])(state.cycle.currentCyclePosition);
        if outPulse>0            
            state.cycle.(['pulseToUse' chanString]) = outPulse;
            updateGuiByGlobal(['state.cycle.pulseToUse' chanString]);
            physOutputSession.addAnalogOutputChannel(...
                state.phys.daq.outputBoard, ...
                ['ao' chanString],...
                'Voltage'...
                );
            physOutputSession.Channels(end).Range=[-10 10];                
            state.phys.internal.lastLinesUsed{end+1}=chanName;            
            hasMainOutput=1;
        end
    end

    for channel=0:state.phys.daq.numDigOutputChannels-1
        chanString=num2str(channel);
        chanName=['do' chanString ];
        outPulse=state.cycle.([chanName 'List'])(state.cycle.currentCyclePosition);
        if outPulse>0 
            physOutputSession.addDigitalChannel(...          
                state.phys.daq.outputBoard, ...
                ['Port0/Line' chanString], 'OutputOnly'); 
            state.phys.internal.lastLinesUsed{end+1}=chanName;            
            hasMainOutput=1;
        end
    end
    
    % HANDLE AUX PHYS OUTPUT BOARD -- but only if the imaging board is not
    % doing it

    haveControlOfAuxBoard=1;
    if timerGetActiveStatus('Imaging')
        if state.cycle.imagingOnList(state.cycle.currentCyclePosition)
            haveControlOfAuxBoard=0;
        end
    end
    
    state.phys.internal.lastAuxLinesUsed={};
    state.phys.internal.lastAuxPulsesUsed=[];
    
    hasAuxOutput=0;
    if ~isempty(state.phys.daq.auxOutputBoard)
        for channel=0:state.phys.daq.numAuxOutputChannels-1
            chanString=num2str(channel);
            chanName=['aux' chanString];
            outPulse=state.cycle.([chanName 'List'])(state.cycle.currentCyclePosition);
            if (outPulse>0) 
                if haveControlOfAuxBoard            
                    physOutputSession.addAnalogOutputChannel(...
                        state.phys.daq.auxOutputBoard, ...
                        ['ao' num2str(channel)], ...
                        'Voltage');
                    physOutputSession.Channels(end).Range=[-10 10];    
                    state.phys.internal.lastLinesUsed{end+1}=chanName;
                    state.phys.internal.lastPulsesUsed(end+1)=outPulse;
                    hasAuxOutput=1;
                else
                    state.phys.internal.lastAuxLinesUsed{end+1}=chanName;
                    state.phys.internal.lastAuxPulsesUsed(end+1)=outPulse;
                end
            end
        end
    end
            
    if hasMainOutput
        addTriggerConnection(physOutputSession, ...
            'external', ...
            [state.phys.daq.outputBoard '/' state.phys.daq.outputTriggerLine], ...
            'StartTrigger');
    end

   
    if hasAuxOutput
        addTriggerConnection(physOutputSession, ...
            'external', ...
            [state.phys.daq.auxOutputBoard '/' state.phys.daq.auxOutputTriggerLine], ...
            'StartTrigger');
%         addClockConnection(physOutputSession, ...
%             [state.phys.daq.outputBoard '/RTSI2'], ...
%             [state.phys.daq.auxOutputBoard '/RTSI2'], ...
%             'ScanClock');
    end
    
    updateHeaderString('state.phys.internal.lastAuxPulsesUsed');
    updateHeaderString('state.phys.internal.lastPulsesUsed');
    updateHeaderString('state.phys.internal.lastAuxLinesUsed');
    updateHeaderString('state.phys.internal.lastLinesUsed');
    state.phys.internal.needNewOutputChannels=0;
    setPhysStatusString('')
    set(gh.advancedCycleGui.physiologyPanel, 'visible', 'on')

 