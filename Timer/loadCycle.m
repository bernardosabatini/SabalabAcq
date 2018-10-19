function loadCycle(pname, fname)
	global state

	if state.internal.cycleChanged
		beep;
		answer=questdlg('Do you want to save changes to the current cycle?', 'SAVE CYCLE?', 'Yes', 'No', 'Cancel', 'Yes');
		if strcmp(answer, 'Cancel')
			return
		elseif strcmp(answer, 'Yes')
			saveCycle;
		end
    end
	
    if nargin==1
        fname=pname;
        pname=state.cycle.cyclePath;
        if ~contains(fname, '.')
            fname=[fname '.cyc']; 
        end
    end
    
	if nargin==0
		if ~isempty(state.cycle.cyclePath)
			try
				cd(state.cycle.cyclePath);
			catch
			end
		end
		[fname, pname]=uigetfile('*.cyc', 'Choose cycle');
    end

	if ~isnumeric(fname) && ~isempty(fname)
		try
			cycle=load(fullfile(pname, fname), '-MAT');
		catch
			beep;
			error(['loadCycle : Unable to load ' fullfile(pname, fname) '. File may be missing or have been moved.'])
		end

        if ~isfield(cycle.cycle, 'nextCycle')
            cycle.cycle.nextCycle='';
        end
		fnames=fieldnames(cycle.cycle);
		for counter=1:length(fnames)
			state.cycle.(fnames{counter})=cycle.cycle.(fnames{counter});
        end
        
		state.cycle.cycleName = fname;
		state.cycle.cyclePath = pname;
    	timerCycle_setDisplayPosition(1);
        for counter=1:length(state.cycle.isCommonToAllPositions)
            updateGuiByGlobal(['state.cycle.' ...
                state.cycle.isCommonToAllPositions{counter}]);
        end
		
		makeCycleMenu;
		checkCurrentCycleInMenu;
		state.internal.cycleChanged=0;
		state.cycle.currentCyclePosition=1;
        state.cycle.repeatsDone=0;
        updateGuiByGlobal('state.cycle.cycleName');
        updateGuiByGlobal('state.cycle.currentCyclePosition');
        updateGuiByGlobal('state.cycle.repeatsDone');        
        setupCycleRandomList
        
		setStatusString('cycle loaded');
	else
		setStatusString('Cannot load cycle');
	end
	
	