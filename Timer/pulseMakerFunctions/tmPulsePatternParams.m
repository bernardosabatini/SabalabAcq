function fN2=tmPulsePatternParams
    global state
    
    fNames=fieldnames(state.pulses);
    fN2={};
    
    if nargout==0
        disp('The parameter names in each pulse pattern are');
    end
    for fCounter=1:length(fNames)
        fName=fNames{fCounter};
        ff=strfind(fName, 'List');
        if ~isempty(ff)
            fNameShort=fName(1:ff(1)-1);
            if nargout==0
                disp(['    ' fNameShort]);
            end
            fN2{end+1}=fNameShort;
        end        
    end
    
    if nargout==0
        fN2=[];
    end
    
    

