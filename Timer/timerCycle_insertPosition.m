function timerCycle_insertPosition(position)
	global state gh

	if nargin<1
		position=state.cycle.displayCyclePosition;
	else
		if position>length(state.cycle.delayList)
			return
		end
	end
	
	state.internal.cycleChanged=1;
    
    fields=fieldnames(state.cycle);
    for counter=1:length(fields)
        fieldList=fields{counter};
        if length(fieldList)>4 && strcmp('List', fieldList(end-3:end))
            field=fieldList(1:end-4);
            if isnumeric(state.cycle.(field))
                minValue=[];
                guiName=getGuiOfGlobal(['state.cycle.' field]);
                if ~isempty(guiName)
                    guiHandle=eval(guiName{1});
                    minValue=getUserDataField(guiHandle, 'Min');
                end
                if isempty(minValue)
                    minValue=0;
                end
        		state.cycle.(fieldList)(position+1:end+1) = state.cycle.(fieldList)(position:end);
                state.cycle.(fieldList)(position)=minValue;
            elseif ischar(state.cycle.(field))
        		state.cycle.(fieldList)(position+1:end+1) = state.cycle.(fieldList)(position:end);
                state.cycle.(fieldList){position}='';
            else
                disp(['state.cycle.' field ' is not numeric or char']);
            end
        end
    end
	timerCycle_setDisplayPosition(position);

