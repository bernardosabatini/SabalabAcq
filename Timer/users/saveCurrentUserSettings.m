function out=saveCurrentUserSettings()
	global state
	out=0;
	
	if isempty(state.userSettingsName) || isnumeric(state.userSettingsName)
		saveCurrentUserSettingsAs;
		return
	end

	setStatusString('Saving user settings...');
	recordWindowPositions;
	[fid, message]=fopen(fullfile(state.userSettingsPath, [state.userSettingsName '.usr']), 'wt');
	if fid==-1
		disp(['saveCurrentUserSettings: Error cannot open output file ' fullfile(state.userSettingsPath, [state.userSettingsName '.usr']) ]);
		setStatusString('Can''t open file...');
		return
	end
	
	createConfigFileFast(4, fid, 1);
	fclose(fid);
	setStatusString('');

	