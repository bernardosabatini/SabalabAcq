function out=valueFromHeaderString(globalName, header)
	out='';
	
	if nargin<2
        global state
		header=state.headerString;
	end
	
	global state
	pos=findstr(header, [globalName '=']);
	
	if isempty(pos)
		out=[];
		return;
	else
		cr=findstr(header, 13);
		index=find(cr>pos);
		next=cr(index(1));
		if isempty(next)
			out=header(pos+length(globalName)+1:end-1);
		else
			out=header(pos+length(globalName)+1:next-1);
		end
	end

		val=str2num(out);
		if length(val)==1
			out=val;
		else
			out=out(2:end-1);
		end

	
	