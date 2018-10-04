function tmCopyCyclePosition(oldP, newP)
	global state
		
    if oldP>length(state.cycle.repeatsList)        
        error(['position ' num2str(oldP) ' does not exist']);
    end
    
    fields=fieldnames(state.cycle);
    for counter=1:length(fields)
        fieldList=fields{counter};
        if length(fieldList)>4 && strcmp('List', fieldList(end-3:end))
            field=fieldList(1:end-4);
            state.cycle.(fieldList)(newP)=state.cycle.(fieldList)(oldP);
        end
    end
    if state.cycle.displayCyclePosition==newP
        timerCycle_setDisplayPosition(state.cycle.displayCyclePosition);
    end
    