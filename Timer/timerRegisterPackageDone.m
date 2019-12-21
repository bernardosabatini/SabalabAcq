function timerRegisterPackageDone(package)
	global state

	if nargin<1
		package=[];
    end
    if isempty(package)
        package=find(state.timer.activePackages);
    end
        
%	disp(['timerRegisterPackageDone: ' package]);
	timerSetPackageStatus(0, package);
    timerCallPackageFunctions('Process', package);	
    if isempty(find(state.timer.packageStatus.*state.timer.activePackages, 1))
        timerExecuteAllPackagesDone();
    end
    