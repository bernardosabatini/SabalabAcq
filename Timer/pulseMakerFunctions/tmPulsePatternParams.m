function tmPulsePatternParams
    global state
    
    fNames=fieldnames(state.pulses);
    
    disp('The parameter names in each pulse pattern are');
    for fCounter=1:length(fNames)
        fName=fNames{fCounter};
        ff=strfind(fName, 'List');
        if ~isempty(ff)
            fNameShort=fName(1:ff(1)-1);
            disp(['    ' fNameShort]);
        end        
    end
    
    

