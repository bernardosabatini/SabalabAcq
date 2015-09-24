function phSession_makeOutput(force)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    global state physOutputData

    if nargin<1
        force=0;
    end

    disp('phSession_makeOutput CALLED')

    % if we don't need to do this, get out of here
    if ~state.phys.internal.needNewOutputData && ~force
        return
    end

    disp('phSession_makeOutput EXECUTING')
    
    physOutputData=[];
    % loop through the main output channels
    for channel=state.phys.internal.outputChannelsUsed
        chanString=num2str(channel);
        patternNum=state.cycle.(['da' chanString 'List'])(state.cycle.currentCyclePosition);
        RSPattern=[];
        if patternNum
            makePulsePattern(patternNum, 0);
            state.cycle.(['lastPulseUsed' chanString])=patternNum;
            gain=1;
            extraGain=state.phys.settings.(['extraGain' chanString]);
            if state.phys.settings.(['channelType' chanString])>1
                if state.phys.settings.(['currentClamp' chanString])
                    gain=state.phys.settings.(['pAPerVOut' chanString]);
                    if state.cycle.CCRCPulse
                        makePulsePattern(state.cycle.CCRCPulse, 0);
                        RSPattern=state.pulses.(['pulsePattern' num2str(state.cycle.CCRCPulse)])';
                    end
                else
                    gain=state.phys.settings.(['mVPerVOut' chanString]);
                    if state.cycle.VCRCPulse
                        makePulsePattern(state.cycle.VCRCPulse, 0);
                        RSPattern=state.pulses.(['pulsePattern' num2str(state.cycle.VCRCPulse)])';
                    end
                end
            end
            
            if isempty(physOutputData)
                physOutputData=(extraGain/gain)*state.pulses.(['pulsePattern' num2str(patternNum)])';
            else
                pattern=state.pulses.(['pulsePattern' num2str(patternNum)]);
                len=max(size(pattern, 2), size(physOutputData,1));
                
                if len>size(physOutputData,1)
                    physOutputData(end+1:len,:)=...
                        repmat(...
                        physOutputData(end,:), ...
                        len-size(physOutputData, 1), ...
                        1);
                end
                if len>size(pattern, 2)
                    pattern(end+1:len)=pattern(end);		% fill with last point repeated
                end
                physOutputData(1:len,end+1) = (extraGain/gain)*pattern(1:len)';
            end
            if ~isempty(RSPattern)
                len=min(size(RSPattern,1),size(physOutputData,1));
                physOutputData(1:len, end)=physOutputData(1:len, end)+(RSPattern(1:len)/gain);
            end
        end
    end
    
    if isempty(physOutputData)
        disp('phSession_makeOutput : No physiology main ouput selected.');
    end

    if state.phys.daq.auxOutputBoard
       chanNeeded=find(...
            [state.cycle.aux4List(state.cycle.currentCyclePosition) ...
            state.cycle.aux5List(state.cycle.currentCyclePosition) ...
            state.cycle.aux6List(state.cycle.currentCyclePosition) ...
            state.cycle.aux7List(state.cycle.currentCyclePosition)])+3;
        
        haveControlOfAuxBoard=1;
        if timerGetActiveStatus('Imaging')
            if state.cycle.imageOnList(state.cycle.currentCyclePosition)
                haveControlOfAuxBoard=0;
            end
        end
        
        if haveControlOfAuxBoard
            if ~isempty(chanNeeded)
                nPoints=size(physOutputData, 1);
                for channel=chanNeeded
                    chanString=num2str(channel);
                    patternNum=state.cycle.(['aux' chanString 'List'])(state.cycle.currentCyclePosition);
                    makePulsePattern(patternNum, 0);
                    pattern=state.pulses.(['pulsePattern' num2str(patternNum)]);
%                     pSize=size(pattern, 2);
%                     if nPoints > pSize
%                         pattern=[pattern repmat(pattern(end), 1, nPoints-pSize)];
%                     end

                    len=max(size(pattern, 2), size(physOutputData,1));

                    if len>size(physOutputData,1)
                        physOutputData(end+1:len,:)=...
                            repmat(...
                            physOutputData(end,:), ...
                            len-size(physOutputData, 1), ...
                            1);
                    end
                    if len>size(pattern, 2)
                        pattern(end+1:len)=pattern(end);		% fill with last point repeated
                    end
                     
                    physOutputData(1:nPoints, end+1)=pattern(1,1:nPoints)';
                end
            end
        end
    end
    
    state.phys.internal.needNewOutputData=0;






