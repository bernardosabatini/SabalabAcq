function updateGuiByName(guiLoc)
% given the name of a GUI, updates its contents to reflect the current state of a global variable
	if ~iscell(guiLoc) || length(guiLoc)==0
		disp(['updateGuiByName: empty GUI name.  No action.']);
		return
	end
	for guiCount=1:length(guiLoc)
		[ghName, guiName, temp]= structNameParts(guiLoc{guiCount});
		eval(['global ' ghName ';']);
		eval(['updateGuiVars(' guiLoc{guiCount} ');']);
	end
