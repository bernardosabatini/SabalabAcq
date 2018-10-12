function out=tokenize(line)
	out={};
	line=deblank(line);
	while (~isempty(line))
		[token, line]=getToken(line);
		if (~isempty(token))
			out{length(out)+1}=token;
		end
	end

function [token, remLine]=getToken(line)
	[token, remLine]=strtok(line);
	if isempty(token)
		return
	end
	
	if any(findstr(token,'''')) 
		while (~isempty(remLine)) && (token(length(token))~='''') 
			[tok2, remLine]=strtok(remLine);
			remLine=remLine(2:length(remLine));
			token=[token ' ' tok2];
		end
		if token(1)=='''' && token(length(token))==''''
			token=token(2:length(token)-1);
		end
	end	
	
