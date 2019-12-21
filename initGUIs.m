function [out,fname,pname,ext]=initGUIs(fileName, callCallbacks, file)
% opens and interprets and initialization file
%

% Author: Bernardo Sabatini 1/21/1
%

out=0;
fname='';
pname='';
ext='';
if nargin~=3
	% open file and read in by line ignoring comments
	fid=fopen(fileName, 'r');
	if fid==-1
		disp(['initGUIs: Error: Unable to open file ' fileName ]);
		return
	else
		out=1;
		[fullName, ~, ~]=fopen(fid);
		fclose(fid);
		[pname, fname, ext]=fileparts(fullName);
	end
	file = textread(fullName,'%s', 'commentstyle', 'matlab', 'delimiter', '\n');
end

callBackList={};
currentStructure=[];
variableList={};

%re= "^\s*structure\s*(?<structName>\w+)|^\s*(?<endStruct>endstructure\s*)|^\s*(?<varName>\w+)\s*(?<varVal>=(\[.*\]|{.*}|'.*'|[\-\.]*\w+))?\s*(?<rest>\w[^%]*)?(?<comment>%.*)?";

% modified to handle all decimals correctly adding [+-]?\d+\.?\d*
re= "^\s*structure\s*(?<structName>\w+)|^\s*(?<endStruct>endstructure\s*)|^\s*(?<varName>\w+)\s*(?<varVal>=(\[.*\]|{.*}|[+-]?\d+\.?\d*|'.*'|[\-\.]*\w+))?\s*(?<rest>\w[^%]*)?(?<comment>%.*)?";

for lineCounter=1:length(file)				% step through each line of the file
	if ~isempty(file{lineCounter})
		tokens=regexpi(file{lineCounter}, re, 'names'); % parse each line according to the regular expression
		
		if ~isempty(tokens)	        		% are there words on this line?
			if ~isempty(tokens.structName)	% are we starting a new structure?
				if ~isempty(currentStructure)
					currentStructure=[currentStructure '.' tokens.structName];
				else
					currentStructure=tokens.structName;
				end
				[topName, structName, fieldName]=structNameParts(currentStructure);
				
				eval(['global ' topName ';']);		% get a global reference to the correct top level variable
				if ~exist(topName,'var')
					eval([topName '=[];']);
				end
				if ~isempty(fieldName)
					if ~eval(['isfield(' structName ',''' fieldName ''');'])
						eval([currentStructure '=[];']);
					end
				end				
			elseif ~isempty(tokens.endStruct)		% are we ending a structure?
				periods=findstr(currentStructure, '.');		% then trim currentStructure depending on whether it
				if any(periods)								% has any subfields
					currentStructure=currentStructure(1:periods(length(periods))-1);
				else
					currentStructure=[];
				end
			elseif ~isempty(tokens.varName)					% it must be a fieldname[=val] [param, value]* line
				fieldName=tokens.varName;					% get fieldName
                
				% check if the variable or struct field exists
				% if not, set it to emply
				if isempty(currentStructure)						% must be a global variable and not the field of a global
					fullVariableName=fieldName;
					eval(['global ' fullVariableName]);				% get access to the global
					if ~exist(fullVariableName,'var')				% if global does not exist...
						eval([fullVariableName '=' [] ';']);		% create it.
					end
				else												% we are dealing with the field of a global
					fullVariableName=[currentStructure '.' fieldName];
					if ~eval(['isfield(' currentStructure ',''' fieldName ''');']) 	% if not, if field does not exist ...
						eval([fullVariableName '=[];'])					% initialize it
					end
				end
				
				% is there an initialization value?
				if ~isempty(tokens.varVal)
					if tokens.varVal(1)~='='
						disp('something wrong - no equal');
					else
						startingValue=tokens.varVal(2:end);
					end
					
					if isempty(startingValue)
						disp('this should never happen value but empty');
						startingValue=[];
					else
						disp([fullVariableName '=' startingValue]);
						eval([fullVariableName '=' startingValue ';']);
					end
				end
				
				variableList=[variableList, {fullVariableName}];
				validGUI=0;
				
				% now handle all the param value pairs
				if ~isempty(tokens.rest) % there are more tokens
					% parse them into param name and value pairs

					pvPairs=regexpi(tokens.rest, '(?<pp>\w+)\s+(?<pv>\S+)+', 'names');
					for pCounter=1:length(pvPairs)
						param=pvPairs(pCounter).pp;
						if param(1)=='%'	% a comment snuck in
							break
						end
						value=pvPairs(pCounter).pv;
						switch param
							case 'Gui'
								if ~existGlobal(value)
									disp(['initGUIs: GUI ' value ' for ' fullVariableName ' does not exist.  Skipping userdata...']);
								else
									validGUI=1;
									addGuiOfGlobal(fullVariableName, value);
									try
										setUserDataByGUIName({value}, 'Global', fullVariableName);
									catch
										error(['initGuis : setUserDataByGUIName gave error : ' fullVariableName ' ' value ' : ' lasterr]);
										validGUI=0;
									end
								end
							case 'Config'				% special case for labelling a global as part of a configuration
								setGlobalConfigStatus(fullVariableName, value);
							case 'Callback'
								if ~any(cellfun(@(x) strcmp(x, value), callBackList))
									callBackList{end+1}=value;
								end
								setUserDataByGlobal(fullVariableName, param, value);	% put in UserData
							case 'Database'
								addDBObservation(fullVariableName, value);
							otherwise										% put everything else in UserData
								if validGUI==1
									vNum=str2double(value);
									if isnumeric(vNum) && (length(vNum)==1)	% can it be a number?
										value=vNum;							% yes, then make it a number
									end
									try
										setUserDataByGlobal(fullVariableName, param, value);	% put in UserData
									catch
										error(['initGuis : setUserDataByGlobal gave error : ' fullVariableName ' ' param ' : ' lasterr]);
									end
								end
						end
					end
				end
				updateGuiByGlobal(fullVariableName);				% update all the GUIs that deal with the global variable
			end
		end
	end
end


% Now execute all the callbacks that were collected during the processing of the
% *.ini.  This ensures that everything is correct after the fields in the GUIs
% have been changed by the initialization.

if nargin<2
	callCallbacks=1;
end

if callCallbacks
	for cCounter=1:length(callBackList)
		funcName=callBackList{cCounter};
		try
			eval(funcName);
		catch
			disp(['doGUICallBack: ' lasterr ' in ' funcName ]);
		end
	end
end

