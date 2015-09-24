function updateGuiByGlobal(globalName)
% given the name of a global variable, find and update the GUI that contains it
	guiLoc=getGuiOfGlobal(globalName);
	if isempty(guiLoc)
		% update header for those variables that do not have GUIs
		updateHeaderString(globalName);		
	else	
		updateGuiByName(guiLoc);	% update the GUI
	end

