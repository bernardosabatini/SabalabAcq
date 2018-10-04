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
	
	if nargin<2
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

		fnames=fieldnames(cycle.cycle);
		for counter=1:length(fnames)
			state.cycle.(fnames{counter})=cycle.cycle.(fnames{counter});
        end
		
% 		for counter=1:length(state.internal.cycleListNames)
%             if isfield(cycle.cycle, [state.internal.cycleListNames{counter} 'List'])
%                 eval(['state.' state.internal.cycleListNames{counter} 'List = cycle.cycle.' state.internal.cycleListNames{counter} 'List;']);
%             else
%                 disp(['Appears to have old cycle definition.  Repairing field: ' state.internal.cycleListNames{counter}]);
%                 if isnumeric(getfield(state.cycle, state.internal.cycleListNames{counter}))
%                     disp('... with numeric field.  Please resave the cycle');
%                     eval(['state.cycle.' state.internal.cycleListNames{counter} 'List = ones(size(cycle.cycle.repeatsList));']);
%                 elseif ischar(getfield(state.cycle, state.internal.cycleListNames{counter}))
%                    eval(['state.cycle.' state.internal.cycleListNames{counter} 'List = repmat({''''}, size(cycle.cycle.repeatsList));']);
%                    disp('... with string field.  Please resave the cycle');
%                 end
%             end
%             
% 		end
        
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
		
		setStatusString('cycle loaded');
	else
		setStatusString('Cannot load cycle');
	end
	
	