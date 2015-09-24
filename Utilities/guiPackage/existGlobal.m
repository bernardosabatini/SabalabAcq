function out=existGlobal(globalName)
% 	out=0;
% 	[topName, structName, fieldName]=structNameParts(globalName);	
% 	eval(['global ' topName]);
% 	if eval(['exist(''' topName ''')'])
% 		if isempty(fieldName)
% 			out=1;
% 		else
% 			if length(structName)>length(topName)
% 				if existGlobal(structName)
% 					if eval(['isfield(' structName ',''' fieldName ''');'])
% 						out=1;
% 					end
% 				end
% 			else
% 				if eval(['isfield(' structName ',''' fieldName ''');'])
% 					out=1;
% 				end
% 			end
% 		end
% 	end

try
    out=evalin('base', ['ishandle(' globalName ')']);
catch exception
    out=0;
end

