function tmCopyPulsePatternWithChange(oldNum, newNum, varargin)
    global state
    
    fNames=fieldnames(state.pulses);
    
    for fCounter=1:length(fNames)
        fName=fNames{fCounter};
        ff=strfind(fName, 'List');
        if ~isempty(ff)
            state.pulses.(fName)(newNum)=state.pulses.(fName)(oldNum);
            fNameShort=fName(1:ff(1)-1);
            if ~isempty(varargin)
                isParam=find(cellfun(@(vv) strcmp(vv, fNameShort), varargin));
                if ~isempty(isParam)
                   state.pulses.(fName)(newNum)=varargin{isParam(1)+1};
                end
            end
        end        
    end
    
    if state.pulses.patternNumber==newNum
        changePulsePatternNumber(newNum);
    end
    makePulsePattern(newNum);

