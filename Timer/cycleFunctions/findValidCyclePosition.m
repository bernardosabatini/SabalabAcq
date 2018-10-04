function validPosition=findValidCyclePosition
	global state
	
	validPosition=0;
	
	if state.cycle.randomize
        if isempty(state.internal.randomPositionsList);
            setupCycleRandomList
        end
        
		fullcycle=0;
		first=1;
		startingPosition=state.internal.randomPosition;
		
		while ~validPosition && ~fullcycle
			% if we're at the end of the cycle, start again
			if state.internal.randomPosition > length(state.internal.randomPositionsList)
				state.internal.randomPosition=1;
				state.cycle.repeatsDone=0;
                if state.cycle.endAfterCycle
                    validPosition=-1;
                    disp('*** Done with cycle. Ending loop');
                    return
                end
				disp('*** New cycle started. ***');
			end
			
			% is something on at this position?
            if ~isempty(state.cycle.functionNameList(state.cycle.currentCyclePosition))
                % if there is a function to call, then yes
                validPosition=1;
            else
                % if there is no function to call, is a package active?
                validPosition=0;
                for packageIndex=find(timerGetActiveStatus())
                    if state.cycle. ...
                            ([state.timer.packageList{packageIndex} ...
                            'OnList'])(state.cycle.currentCyclePosition)
                        validPosition=1;
                        break
                    end
                end
            end
 
			if ~validPosition
				state.internal.randomPosition = state.internal.randomPosition + 1;
				if state.internal.randomPosition > length(state.internal.randomPositionsList)
                    state.internal.randomPosition=1;
                    state.cycle.repeatsDone=0;
                    if state.cycle.endAfterCycle
                        validPosition=-1;
                        disp('*** Done with cycle. Ending loop');
                        return
                    end
                    disp('*** New cycle started. ***');
				end
			end
			
			if ~validPosition && ~first && (startingPosition==state.internal.randomPosition)
				fullcycle=1;
				setStatusString('INVALID CYCLE');
				error('findValidCyclePosition: no valid cycle position found');
			end
			first=0;
			
			state.cycle.currentCyclePosition=state.internal.randomPositionsList(state.internal.randomPosition);
			updateGuiByGlobal('state.cycle.currentCyclePosition');
			if state.internal.randomPosition>1
				state.cycle.repeatsDone=length(find(state.internal.randomPositionsList(1:state.internal.randomPosition-1)==state.cycle.currentCyclePosition));
			else
				state.cycle.repeatsDone=0;
			end
			updateGuiByGlobal('state.cycle.repeatsDone');
		end		
	else
		fullcycle=0;
		first=1;

		startingPosition=state.cycle.currentCyclePosition;
		
		while ~validPosition && ~fullcycle
			% if we did all the repeats, then advance in the cycle
	
			if state.cycle.repeatsDone>=state.cycle.repeatsList(state.cycle.currentCyclePosition)
				state.cycle.currentCyclePosition = state.cycle.currentCyclePosition + 1;
				state.cycle.repeatsDone=0;
				updateGuiByGlobal('state.cycle.currentCyclePosition');
				updateGuiByGlobal('state.cycle.repeatsDone');
			end
			
			% if we're at the end of the cycle, start again
			if state.cycle.currentCyclePosition > length(state.cycle.delayList)
				state.cycle.currentCyclePosition=1;
				state.cycle.repeatsDone=0;
				updateGuiByGlobal('state.cycle.currentCyclePosition');
				updateGuiByGlobal('state.cycle.repeatsDone');
                if state.cycle.endAfterCycle
                    validPosition=-1;
                    disp('*** Done with cycle. Ending loop');
                    return
                end
				disp('*** New cycle started. ***');
			end
			
			% is the current position valid?
			% is something on at this position?
            if ~isempty(state.cycle.functionNameList(state.cycle.currentCyclePosition))
                % if there is a function to call, then yes
                validPosition=1;
            else
                % if there is no function to call, is a package active?
                validPosition=0;
                for packageIndex=find(timerGetActiveStatus());
                    if state.cycle. ...
                            ([state.timer.packageList{packageIndex} ...
                            'OnList'])(state.cycle.currentCyclePosition)
                        validPosition=1;
                        break
                    end
                end
            end
			
			if ~validPosition
				state.cycle.currentCyclePosition = state.cycle.currentCyclePosition + 1;
				state.cycle.repeatsDone=0;
				if state.cycle.currentCyclePosition > length(state.cycle.delayList)
					state.cycle.currentCyclePosition=1;
                    if state.cycle.endAfterCycle
                        validPosition=-1;
                        disp('*** Done with cycle. Ending loop');
                        return
                    end
					disp('*** New cycle started. ***');
                end
				updateGuiByGlobal('state.cycle.currentCyclePosition');
				updateGuiByGlobal('state.cycle.repeatsDone');
			end
			
			if ~validPosition && ~first && (startingPosition==state.cycle.currentCyclePosition)
				fullcycle=1;
				setStatusString('INVALID CYCLE');
				error('findValidCyclePosition: no valid cycle position found');
			end
			first=0;
		end
	end
		
		

