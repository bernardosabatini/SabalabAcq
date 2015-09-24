function timerSetActiveStatus(packageList, status, noInitCall)
	
    if nargin<3
        noInitCall=0;
    end
    if nargin<2
		status=1;
	end
	if nargin<1
		error('timerSetActiveStatus: please provide package name');
	end;

	if isempty(packageList)
		return
	end
	
	indexList=timerGetPackageListIndices(packageList);
	if isempty(indexList)
		disp(['timerSetActiveStatus: no valid packages: ' packageList]);
		return
	end
	
	global state gh
	for index=indexList
        state.timer.activePackages(index)=status;
        if status	% package was turned on;  if not initialized, then do it now
            if ~state.timer.initializedPackages(index)
                state.timer.initializedPackages(index)=1;
                state.timer.triggerPackages(index)=...
                    timerCallPackageFunctions(...
                    'HasTrigger', ...
                    state.timer.packageList(index)...
                    );
                timerCallPackageFunctions('MergeCycleGui'); % Stack GUI windows
                timerCallPackageFunctions('InitGUI');  % Opens Phys Controls, scope & LineMonitor GUI window & read ini files
                if ~noInitCall
                    timerCallPackageFunctions('Init');
                end
            end
        end
            
		if ishandle(gh.timerMainControls.Packages)	% set the flag in the menu
			menuIndex=length(state.timer.packageList)-index+1;
			children=get(gh.timerMainControls.Packages, 'Children');
			if status
				set(children(menuIndex), 'Checked', 'on');
			else
				set(children(menuIndex), 'Checked', 'off');
			end
		end
    end
    
 