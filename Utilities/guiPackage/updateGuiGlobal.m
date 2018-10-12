function updateGuiGlobal(handle)
% update the value of a Global value to match that contained in its GUI
	if hasUserDataField(handle, 'Global')
		gName=getUserDataField(handle, 'Global');
		
		[topName, structName, fieldName]=structNameParts(gName);
		val=getGuiValue(handle);
		if isnumeric(val)
			val=num2str(val);
        else
            val=strrep(val, '''', '');
			val=['''' val ''''];
		end
		eval(['global ' topName]);
		if exist(topName, 'var')
			if ~isempty(structName)
				eval([structName '=setfield(' structName ',''' fieldName ''',' val ');']);	
			else
				eval([topName '=' val ';']);
			end
			updateGuiByGlobal(gName);	
		else
			Disp(['Error: global ' topName ' not found']);
		end
	end
		