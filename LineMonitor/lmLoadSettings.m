function lmLoadSettings(fileName)
	global state
	
	if (nargin<1) || isempty(fileName)
		[fname, pname]=uigetfile('*.mat', 'Select file for settings');
		if isempty(fname) || isnumeric(fname)
			setStatusString('Load canceled')
		end
		fileName=fullfile(pname, fname);
	end

	loaded=load(fileName);
	
	fnames=fieldnames(loaded.lm);
	for counter=1:length(fnames)
		fname=fnames{counter};
		state.lm.(fname)=loaded.lm.(fname);
		updateGuiByGlobal(['state.lm.' fname]);
    end
    
    lmMakeDeviceIDList
	lmBuildDAQs
	
	
	

	
	
	

		