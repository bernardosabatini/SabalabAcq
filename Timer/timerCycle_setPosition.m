function timerCycle_setPosition(pos)
% change the cycle position -- not the display -- what will be executed
% next
    global state 
		
	try
		if nargin==1
			state.cycle.currentCyclePosition=pos;
			updateGuiByGlobal('state.cycle.currentCyclePosition');
		end
		global state
		state.cycle.repeatsDone=0;
		updateGuiByGlobal('state.cycle.repeatsDone');
		if state.cycle.currentCyclePosition>length(state.cycle.delayList)
			state.cycle.currentCyclePosition = length(state.cycle.delayList);
			updateGuiByGlobal('state.cycle.currentCyclePosition');
		end
		timerCycle_applyPosition;

		if state.cycle.loopingStatus
			timerCallPackageFunctions('Setup');
		end
		
	catch
		disp(['timerCycle_setPosition : ' lasterr]);
	end
