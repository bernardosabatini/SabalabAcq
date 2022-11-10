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
        nList=length(cycle.cycle.delayList);
        
		for counter=1:length(fnames)
            fff=fnames{counter};
            if length(fff)>4
                if strcmp(fff(end-3:end),'List')
                    if length(cycle.cycle.(fff))>nList
                        disp(['   ' fff ' has too many entries.  Trimming. Check and resave']);
                        state.cycle.(fff)=cycle.cycle.(fff)(1:nList);
                    else
            			state.cycle.(fff)=cycle.cycle.(fff);
                        if length(cycle.cycle.(fff))<nList
                            disp(['   ' fff ' may be corrupted and missing entries. Autofilling.  Check and resave']);
                        	state.cycle.(fff)(end:nList)=state.cycle.(fff)(end);
                        end
                    end
                else
                    state.cycle.(fff)=cycle.cycle.(fff);
                end
            else
    			state.cycle.(fff)=cycle.cycle.(fff);
            end
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
        timerCycle_updateMaxCyclePos

		state.internal.cycleChanged=0;
		state.cycle.currentCyclePosition=1;
        state.cycle.repeatsDone=0;
        updateGuiByGlobal('state.cycle.cycleName');
        updateGuiByGlobal('state.cycle.currentCyclePosition');
        updateGuiByGlobal('state.cycle.repeatsDone');        
        setupCycleRandomList

        addEntryToNotebook(2, ['LOADED CYCLE ' state.cycle.cycleName]);
        
		disp(['*** cycle ' fname ' loaded']);
		setStatusString(['cycle loaded']);
	else
		disp(['*** cannot load cycle' fname]);
		setStatusString(['Cannot load cycle']);
	end
	
	