function timerCycle_deletePosition(position)
	global state gh

	if nargin<1
		position=state.cycle.displayCyclePosition;
	else
		if position>length(state.cycle.delayList)
			return
		end
    end
	
    if position==1 && length(state.cycle.delayList)==1
        return
    end
    state.internal.cycleChanged=1;
    
    fields=fieldnames(state.cycle);
    for counter=1:length(fields)
        fieldList=fields{counter};
        if length(fieldList)>4 && strcmp('List', fieldList(end-3:end))
            field=fieldList(1:end-4);
       		state.cycle.(fieldList)(position) = [];
        end
    end
	timerCycle_setDisplayPosition(min(position, length(state.cycle.delayList)));
