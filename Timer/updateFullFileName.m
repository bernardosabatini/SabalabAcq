function updateFullFileName
	global state
	if ~ischar(state.files.baseName)
		state.files.baseName='';
	end
	if ~ischar(state.files.savePath)
		state.files.savePath='';
	end
	
	state.files.fullFileName=fullfile(state.files.savePath, [state.files.baseName zeroPadNum2Str(state.files.fileCounter)]);
	