function phSession_makeOutput(force)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    global state physOutputData

    if nargin<1
        force=0;
    end

%    disp('phSession_makeOutput CALLED')

    % if we don't need to do this, get out of here
    if ~state.phys.internal.needNewOutputData && ~force
        return
    end

%    disp('phSession_makeOutput EXECUTING')
    
    % is physiology controlling the aux board or is imaging?
    haveControlOfAuxBoard=0;
    if state.phys.daq.auxOutputBoard
        haveControlOfAuxBoard=1;
        if timerGetActiveStatus('Imaging')
            if state.cycle.imagingOnList(state.cycle.currentCyclePosition)
                haveControlOfAuxBoard=0;
            end
        end
    end

    physOutputData=[];
    % loop through the main output channels
    for chanCounter=1:length(state.phys.internal.lastLinesUsed)
        chanName=state.phys.internal.lastLinesUsed{chanCounter};
        if strcmp(chanName(1:2), 'ao')        
            chanString=chanName(3:end);
        elseif strcmp(chanName(1:2), 'do')        
            chanString=chanName(3:end);
        elseif strcmp(chanName(1:3), 'aux')        
            chanString=chanName(4:end);
        else
            error([chanName ' is unknown channel type']);
        end 
        channel=str2double(chanString);

        patternNum=state.cycle.([chanName 'List'])(state.cycle.currentCyclePosition);
        state.phys.internal.lastPulsesUsed(chanCounter)=patternNum;
        RSPattern=[];
        if (patternNum>0)
            makePulsePattern(patternNum, 0);
            state.phys.internal.(['pulseString_' chanName])=state.pulses.pulseStrings{patternNum};
            
            gain=1;
            extraGain=1;
            
            if strcmp(chanName(1:2), 'ao') && channel<2
                state.phys.internal.(['pulseToUse' chanString])=patternNum;
                state.phys.internal.(['pulseUsed' chanString])=patternNum;
                updateGuiByGlobal(['state.phys.internal.pulseToUse' chanString]);
                
                extraGain=state.phys.settings.(['extraGain' chanString]);
                if state.phys.settings.(['channelType' chanString])>1
                    if state.phys.settings.(['currentClamp' chanString])
                        gain=state.phys.settings.(['pAPerVOut' chanString]);
                        if state.cycle.CCRCPulse
                            makePulsePattern(state.cycle.CCRCPulse, 0);
                            RSPattern=state.pulses.(['pulsePattern' num2str(state.cycle.CCRCPulse)]);
                            state.phys.internal.pulseString_RCCheck=state.pulses.pulseStrings{state.cycle.CCRCPulse};
                        else
                            state.phys.internal.pulseString_RCCheck='';
                        end
                    else
                        gain=state.phys.settings.(['mVPerVOut' chanString]);
                        if state.cycle.VCRCPulse
                            makePulsePattern(state.cycle.VCRCPulse, 0);
                            RSPattern=state.pulses.(['pulsePattern' num2str(state.cycle.VCRCPulse)]);
                             state.phys.internal.pulseString_RCCheck=state.pulses.pulseStrings{state.cycle.VCRCPulse};
                        else
                            state.phys.internal.pulseString_RCCheck='';
                        end
                    end
                end
                updateHeaderString(['state.phys.internal.pulseString_RCCheck']);
            end

            patternData=(extraGain/gain)*state.pulses.(['pulsePattern' num2str(patternNum)]);
            if ~isempty(RSPattern)
                len=min(length(RSPattern),length(patternData));
                patternData(1:len)=patternData(1:len)+RSPattern(1:len)/gain;
            end
            if strcmp(chanName(1:2), 'ao') || strcmp(chanName(1:3), 'aux')
                if max(patternData)>10
                    patternData=min(patternData,10);
                    disp(['    !!!WARNING: phSession_makeOutput: pattern ' num2str(patternNum) ' output clipped high (+10V)']);
                end
                if min(patternData)<-10
                    patternData=max(patternData,-10);
                    disp(['    !!!WARNING: phSession_makeOutput: pattern ' num2str(patternNum) ' output clipped low (-10V)']);
                end
            elseif strcmp(chanName(1:2), 'do')
                if max(patternData)>1
                    patternData=min(patternData,1);
                    disp(['    !!!WARNING: phSession_makeOutput: pattern ' num2str(patternNum) ' output clipped high (1 logical)']);
                end
                if min(patternData)<0
                    patternData=max(patternData,0);
                    disp(['    !!!WARNING: phSession_makeOutput: pattern ' num2str(patternNum) ' output clipped low (0 logical)']);
                end
            end
                
            if isempty(physOutputData)
                physOutputData=patternData';
            else
                len=max(length(patternData), size(physOutputData,1));
                
                if len>size(physOutputData,1)
                    physOutputData(end+1:len,:)=...
                        repmat(...
                        physOutputData(end,:), ...
                        len-size(physOutputData, 1), ...
                        1);
                end
                if len>size(patternData, 2)
                    patternData(end+1:len)=patternData(end);		% fill with last point repeated
                end
                if strcmp(chanName(1:3), 'aux')
                    if haveControlOfAuxBoard
                        physOutputData(1:len,end+1) = patternData';
                    end
                else
                    physOutputData(1:len,end+1) = patternData';
                end
            end
        else
            state.phys.internal.(['pulseString_' chanName])='';
        end
        updateHeaderString(['state.phys.internal.pulseString_' chanName]);
    end
    
    if isempty(physOutputData)
        disp('phSession_makeOutput : No physiology main ouput selected.');
    end
    
    
    updateHeaderString('state.phys.internal.lastAuxPulsesUsed');
    updateHeaderString('state.phys.internal.lastPulsesUsed');

    state.phys.internal.needNewOutputData=0;






