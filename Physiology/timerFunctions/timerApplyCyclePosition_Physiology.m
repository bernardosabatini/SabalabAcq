function  timerApplyCyclePosition_Physiology
    % look at what need to be done at this cycle position and get the
    % physiology package ready to do it

    global state

    physiologyOn=state.cycle.physiologyOnList(state.cycle.currentCyclePosition);
    timerSetActiveStatus('Physiology', physiologyOn);

    % compare required output channels to those previsouly used to
    % understand if the output session needs to be rebuilt

    state.phys.internal.linesToUse={};
    state.phys.internal.pulsesToUse=[];

    for channel=0:state.phys.daq.numOutputChannels-1
        chanString=num2str(channel);
        chanName=['ao' chanString];
        outPulse=state.cycle.([chanName 'List'])(state.cycle.currentCyclePosition);
        if outPulse>0
            state.phys.internal.linesToUse{end+1}=chanName;
            state.phys.internal.pulsesToUse(end+1)=outPulse;
        end
    end

    for channel=0:state.phys.daq.numDigOutputChannels-1
        chanString=num2str(channel);
        chanName=['do' chanString];
        outPulse=state.cycle.([chanName 'List'])(state.cycle.currentCyclePosition);
        if outPulse>0
            state.phys.internal.linesToUse{end+1}=chanName;
            state.phys.internal.pulsesToUse(end+1)=outPulse;
        end
    end

    state.phys.internal.auxLinesToUse={};
    state.phys.internal.auxPulsesToUse=[];

    haveControlOfAuxBoard=1;
    if timerGetActiveStatus('Imaging')
        if state.cycle.imagingOnList(state.cycle.currentCyclePosition)
            haveControlOfAuxBoard=0;
        end
    end    
    
    if state.phys.daq.auxOutputBoard
        for channel=0:state.phys.daq.numAuxOutputChannels-1
            chanString=num2str(channel);
            chanName=['aux' chanString];
            outPulse=state.cycle.([chanName 'List'])(state.cycle.currentCyclePosition);
            if outPulse>0
                if haveControlOfAuxBoard
                    state.phys.internal.linesToUse{end+1}=chanName;
                    state.phys.internal.pulsesToUse(end+1)=outPulse;
                else
                    state.phys.internal.auxLinesToUse{end+1}=chanName;
                    state.phys.internal.auxPulsesToUse(end+1)=outPulse;
                end
                    
            end
        end
    end
    
    if physiologyOn % physiology is on
        if length(state.phys.internal.lastLinesUsed)~=length(state.phys.internal.linesToUse)
             state.phys.internal.needNewOutputChannels=1;
        elseif ~all(strcmp(state.phys.internal.lastLinesUsed,state.phys.internal.linesToUse))
             state.phys.internal.needNewOutputChannels=1;
        end
        
        if state.phys.internal.needNewOutputChannels
            state.phys.internal.needNewOutputData=1;
        elseif length(state.phys.internal.lastPulsesUsed)~=length(state.phys.internal.pulsesToUse)
            state.phys.internal.needNewOutputData=1;
        elseif any(state.phys.internal.lastPulsesUsed~=state.phys.internal.pulsesToUse)
            state.phys.internal.needNewOutputData=1;
        end
        
        if state.phys.daq.auxOutputBoard
            if length(state.phys.internal.lastAuxLinesUsed)~=length(state.phys.internal.auxLinesToUse)
                 state.phys.internal.needNewOutputChannels=1;
            elseif ~all(strcmp(state.phys.internal.lastAuxLinesUsed,state.phys.internal.auxLinesToUse))
                 state.phys.internal.needNewOutputChannels=1;
            end

            if state.phys.internal.needNewOutputChannels
                state.phys.internal.needNewOutputData=1;
            elseif length(state.phys.internal.lastAuxPulsesUsed)~=length(state.phys.internal.auxPulsesToUse)
                state.phys.internal.needNewOutputData=1;
            elseif any(state.phys.internal.lastAuxPulsesUsed~=state.phys.internal.auxPulsesToUse)
                state.phys.internal.needNewOutputData=1;
            end
        end
    end

    if state.phys.internal.needNewOutputChannels
        phSession_buildOutput;
        state.phys.internal.needNewOutputChannels=0;
        state.phys.internal.needNewOutputData=1;
    end




