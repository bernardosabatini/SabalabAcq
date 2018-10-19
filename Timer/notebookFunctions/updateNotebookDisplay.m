function updateNotebookDisplay(linePosition)
	global state 
		
    nbTextName=['notebookText' num2str(state.notebook.notebookNumber)];
	if ~iscell(state.notebook.(nbTextName))
		state.notebook.(nbTextName)={};
	end
	
	notebookSize=size(state.notebook.(nbTextName), 2);
    if nargin==1
        state.notebook.linePosition=linePosition;
    else
        state.notebook.linePosition=max(1, notebookSize-5);
    end
	state.notebook.linePositionFlip=1001-state.notebook.linePosition+1;
	updateGuiByGlobal('state.notebook.linePositionFlip');
%    updateGuiByGlobal('state.notebook.linePosition');
    
    for counter=1:7
		state.notebook.(['pos' num2str(counter)]) = ...
            counter+state.notebook.linePosition-1;
		updateGuiByGlobal(['state.notebook.pos' num2str(counter)]);
		if notebookSize<(state.notebook.linePosition+counter-1)
			state.notebook.(['line' num2str(counter)])='';
		else
			state.notebook.(['line' num2str(counter)])= ...
				state.notebook.(nbTextName){state.notebook.linePosition+counter-1};
		end
		updateGuiByGlobal(['state.notebook.line' num2str(counter)]);
	end