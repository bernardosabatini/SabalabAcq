function timerCycle_setDisplayPosition(position)
	global state gh

	createPosition=0;
	if nargin<1
		position=state.cycle.displayCyclePosition;
	else
		if position>length(state.cycle.delayList)
			position=length(state.cycle.delayList)+1;
            createPosition=1;
		end
		state.cycle.displayCyclePosition=position;
		updateGuiByGlobal('state.cycle.displayCyclePosition');

    end
	
    fields=fieldnames(state.cycle);
    for counter=1:length(fields)
        fieldList=fields{counter};
        if length(fieldList)>4 && strcmp('List', fieldList(end-3:end))
            field=fieldList(1:end-4);
            if position>length(state.cycle.(fieldList))
                createPosition=1;

                if ~isfield(state.cycle, field) || isnumeric(state.cycle.(field))
%                     minValue=[];
%                     guiName=getGuiOfGlobal(['state.cycle.' field]);
%                     if ~isempty(guiName)
%                         guiHandle=eval(guiName{1});
%                         minValue=getUserDataField(guiHandle, 'Min');
%                     end
%                     if isempty(minValue)
%                         minValue=0;
%                     end
%                     state.cycle.(field)=minValue;
                    state.cycle.(field)=state.cycle.(fieldList)(end);
                    state.cycle.(fieldList)(position)=state.cycle.(field);
                elseif ischar(state.cycle.(field))
%                     state.cycle.(field)='';
                    state.cycle.(field)=state.cycle.(fieldList){end};
                    state.cycle.(fieldList){position}=state.cycle.(field);
%                 elseif iscell(state.cycle.(field))
%                     state.cycle.(field)={''};
%                     state.cycle.(fieldList)(position)=state.cycle.(field);
                else
                    disp(['state.cycle.' field ' is not numeric or char']);
                end
            else
                if isfield(state.cycle, field)
                    if isnumeric(state.cycle.(field))
                        state.cycle.(field)=state.cycle.(fieldList)(position);
                    else
                        state.cycle.(field)=state.cycle.(fieldList){position};
                    end
                end
            end
            updateGuiByGlobal(['state.cycle.' field]);
        end
    end
    
    if createPosition
        disp('*** New cycle position created and autofilled');
        setStatusString('NEW POSITION')
    else
        setStatusString('')
    end
    
    
    