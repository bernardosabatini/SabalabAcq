function timerSetCycleActivePackagesStatus(position)
	global state
	if nargin<1
        position=state.cycle.currentCyclePosition;
    end
    
    for pIndex=find(state.timer.initializedPackages)
        cyclePositionOnList= ...
             state.cycle.([lower(state.timer.packageList{pIndex}) 'OnList']);
        timerSetActiveStatus(state.timer.packageList{pIndex},  ...
            cyclePositionOnList(position));
    end
			