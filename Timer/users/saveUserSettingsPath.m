function saveUserSettingsPath(userPath)

	if nargin<1
		global state
		userPath=state.userSettingsPath;
    end
    try
        save(...
            fullfile(matlabroot, 'lastUserPath.mat'), 'userPath', '-mat');
    catch
        disp('cannot save laserUserPath.mat');
    end
	

	