function out=savingInfoIsOK(varargin)
% returns 1 if there is a save path set

	global state
	if state.files.autoSave==0			% BSMOD2
		out=1;
		disp([clockToString(clock) ' *** Acquiring with auto saving off ***']);
		return
	end		

	out=0;

    if isempty(state.files.baseName) %if no base name is chosen
        disp('*** WARNING: No basename selected');
    end
    
	if isempty(state.files.savePath)
		button = questdlg('A Save path has not been selected.','Do you wish to:','Select New Path','Cancel','Select New Path');
        if strcmp(button,'Select New Path')
            setSavePath;
		end
    end
    
    if isempty(state.files.savePath)
		disp('*** ERROR: Please set a save path using save ''File\Header Structure As...'' ***');
		setStatusString('Select Save Path');
		beep;
		return
	end

	updateFullFileName;
	disp([clockToString(clock) ' *** '''  state.files.fullFileName ''' ***']); 
	out=1;
	
		
		
		