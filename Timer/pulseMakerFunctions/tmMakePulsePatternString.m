function outString = tmMakePulsePatternString(pNum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    outString='';
    
    global state
    fNames=fieldnames(state.pulses);
    for fCounter=1:length(fNames)
       fName=fNames{fCounter};
       ff=strfind(fName, 'List');
       if ~isempty(ff)
           fNameShort=fName(1:ff(1)-1);
           val=state.pulses.(fName)(pNum);
           if isnumeric(val)
               val=num2str(val);
%            elseif iscell(val)
%                val=val{1};
%                if ~ischar(val)
%                    val='';
%                end
%            end
             outString=[outString fNameShort '=' val ';'];
           end
       end        
    end
end

