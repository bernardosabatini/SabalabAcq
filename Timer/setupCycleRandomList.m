function setupCycleRandomList
	global state
	
    nList=length(state.cycle.delayList);
    Valid=[];
    for pIndex=find(timerGetActiveStatus())
        Valid=unique([Valid, 
            find(state.cycle.([lower(state.timer.packageList{pIndex}) 'OnList'])(1:min(nList,end)))]);
    end
    
    Valid=sort(unique([find(cellfun(@(x) ~isempty(x), state.cycle.functionNameList(1:min(nList, end)))), Valid]));
        
    temp=[];
	for counter=Valid
		if state.cycle.repeatsList(counter)>0 
			temp(end+1:end+state.cycle.repeatsList(counter))=counter;
		end
    end
    if ~isempty(temp)
		state.internal.randomPositionsList=temp(randperm(length(temp)));
	else
		state.internal.randomPositionsList=0;
	end
	state.internal.randomPosition=1;

    state.cycle.currentCyclePosition=1;
    state.cycle.repeatsDone=0;
    updateGuiByGlobal('state.cycle.currentCyclePosition');
    updateGuiByGlobal('state.cycle.repeatsDone');        
		
			