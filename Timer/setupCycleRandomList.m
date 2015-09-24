function setupCycleRandomList
	global state
	
    temp=[]; phys_indx=[]; imag_indx=[];
    if isfield(state.cycle, 'physiologyOnList')
        phys_indx=find(state.cycle.physiologyOnList);
    end
    if isfield(state.cycle, 'imagingOnList')
        imag_indx=find(state.cycle.imagingOnList);
    end
    Valid=unique([phys_indx,imag_indx]);
        
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
		
			