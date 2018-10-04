function saveCycle
% writes pulseSet to disk

	global state
	
    cycle=[];
	if isempty(state.cycle.cyclePath) || isempty(state.cycle.cycleName)
		saveCycleAs;
	else
		for counter=1:length(state.internal.cycleListNames)
			cycle.([state.internal.cycleListNames{counter} 'List']) = ...
                state.cycle.([state.internal.cycleListNames{counter} 'List']);           
%			eval(['cycle.' state.internal.cycleListNames{counter} 'List = state.cycle.' state.internal.cycleListNames{counter} 'List;']);
        end

        for counter=1:length(state.cycle.isCommonToAllPositions)
			cycle.(state.cycle.isCommonToAllPositions{counter}) = ...
                state.cycle.(state.cycle.isCommonToAllPositions{counter});
% 			eval(['cycle.' state.cycle.isCommonToAllPositions{counter} '=state.cycle.' state.cycle.isCommonToAllPositions{counter} ';']);
        end
		
		save(fullfile(state.cycle.cyclePath, state.cycle.cycleName), 'cycle', '-MAT');
		state.internal.cycleChanged=0;
		setStatusString('cycle saved');
	end
