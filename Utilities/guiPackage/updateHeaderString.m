function updateHeaderString(globalName)
	global state

	flag=getGlobalConfigStatus(globalName);
	if ~bitand(flag, 2)
		return
	end
	
	pos=findstr(state.headerString, [globalName '=']);
	
	val=eval(globalName);
	if iscell(val)
        % here we will assume that cell arrays are only cells of strings
        outString='';
        for cc=1:length(val)
            if ischar(val{cc})
                outString=[outString '''' val{cc} ''' '];
            else
                outString=[outString ''''  ''' '];
            end
        end
        val=['{' outString '}'];
    elseif ~isnumeric(val) && ~ischar(val)
		val
		disp(['updateHeaderString: unknown type for ' globalName]);
		val='0';
	elseif isnumeric(val)
        if length(val) ~=1
            val=['[' num2str(val) ']'];
        else                                              
            val=num2str(val);
        end
	else
		val=['''' val ''''];
	end

	if isempty(pos)
		state.headerString=[state.headerString globalName '=' val 13];
	else
		cr=strfind(state.headerString, 13);
		index=find(cr>pos);
		next=cr(index(1));
		if isempty(next)
			state.headerString=[state.headerString(1:pos-1) globalName '=' val 13];
		else
			state.headerString=[state.headerString(1:pos-1) globalName '=' val state.headerString(next:end)];
		end
	end
	
