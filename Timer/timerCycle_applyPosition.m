function timerCycle_applyPosition(position)
	global state

	if nargin==1
		state.cycle.currentCyclePosition=position;
		updateGuiByGlobal('state.cycle.currentCyclePosition');
	end

	% is there is a text function call in the cycle
	% execute it
	if ~isempty(state.cycle.functionNameList{state.cycle.currentCyclePosition})
		evalin('base', state.cycle.functionNameList{state.cycle.currentCyclePosition});
	end
		
	timerCallPackageFunctions('ApplyCyclePosition');
    
	state.cycle.nextTimeDelay=state.cycle.delayList(state.cycle.currentCyclePosition);
	updateGuiByGlobal('state.cycle.nextTimeDelay');

	state.cycle.lastPositionUsed=state.cycle.currentCyclePosition;
	
	
