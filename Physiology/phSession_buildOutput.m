function phSession_buildOutput(force)
	if nargin<1
		force=0;
    end

    disp('phSession_buildOutput CALLED')
	
    global state physOutputSession 

    if state.phys.internal.runningMode
        return
    end
    
    if ~state.phys.internal.needNewOutputChannels && ~force
        return
    end

    disp('phSession_buildOutput EXECUTING')
    
    delete(physOutputSession);
    
    physOutputSession = daq.createSession('ni');
    physOutputSession.Rate=state.phys.settings.outputRate;

    state.phys.internal.outputChannelsUsed=[];
    state.phys.internal.auxOutputChannelsUsed=[];
    
    madeNewOutput=0;
        
    for channel=0:state.phys.daq.numOutputChannels-1
        chanString=num2str(channel);
        if state.cycle.(['da' chanString 'List'])(state.cycle.currentCyclePosition)>0            
            state.cycle.(['pulseToUse' chanString]) = ...
                state.cycle.(['da' chanString 'List'])(state.cycle.currentCyclePosition);
            updateGuiByGlobal(['state.cycle.pulseToUse' chanString]);
            physOutputSession.addAnalogOutputChannel(...
                state.phys.daq.outputBoard, ...
                ['ao' chanString],...
                'Voltage'...
                );
            physOutputSession.Channels(end).Range=[-10 10];                
            madeNewOutput=1;
            state.phys.internal.outputChannelsUsed(end+1)=channel;
        end
    end

    if madeNewOutput
        if isempty(state.timer.triggerLine)
            physOutputSession.addTriggerConnection(...
                'external', ...
                [state.phys.daq.outputBoard '/RTSI1'], ...
                'StartTrigger');
        else
            physOutputSession.addTriggerConnection(...
                'external', ...
                state.timer.triggerLine, ...    
                'StartTrigger');
        end
    end

    state.phys.internal.needNewOutputData=1;

    % HANDLE AUX PHYS OUTPUT BOARD -- but only if the imaging board is not
    % doing it

    haveControlOfAuxBoard=1;
    if timerGetActiveStatus('Imaging')
        if state.cycle.imageOnList(state.cycle.currentCyclePosition)
            haveControlOfAuxBoard=0;
        end
    end

    madeNewOutput=0;
    if haveControlOfAuxBoard && ~isempty(state.phys.daq.auxOutputBoard)
       chanNeeded=find(...
            [state.cycle.aux4List(state.cycle.currentCyclePosition) ...
            state.cycle.aux5List(state.cycle.currentCyclePosition) ...
            state.cycle.aux6List(state.cycle.currentCyclePosition) ...
            state.cycle.aux7List(state.cycle.currentCyclePosition)])+3;
        if ~isempty(chanNeeded) 
            madeNewOutput=1;
            for channel=chanNeeded
                physOutputSession.addAnalogOutputChannel(...
                    state.phys.daq.auxOutputBoard, ...
                    ['ao' num2str(channel)], ...
                    'Voltage');
                physOutputSession.Channels(end).Range=[-10 10];    
                state.phys.internal.auxOutputChannelsUsed(end+1)=channel;
            end
            madeNewOutput=1;                

            state.phys.internal.needNewOutputData=1;
        end    
    end

    state.phys.internal.needNewOutputChannels=0;
 