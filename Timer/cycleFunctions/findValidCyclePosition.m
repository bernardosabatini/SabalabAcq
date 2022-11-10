function testPosition=findValidCyclePosition
global state

if state.cycle.randomize
    if isempty(state.internal.randomPositionsList)
        setupCycleRandomList
    end
    startingPosition=state.internal.randomPosition;
else
    startingPosition=state.cycle.currentCyclePosition;
end

first=1;
isValid=0;

%%
    function valid=isPositionValue(pos)
        % is the current position valid?
        % is something on at this position?
        valid=0;
        fn=state.cycle.functionNameList(pos);
        if ~isempty(fn) && ~isempty(fn{1})
            % if there is a function to call, then yes
            valid=1;
        else
            % if there is no function to call, is a package active?
            for pIndex=find(state.timer.initializedPackages)
                if state.cycle. ...
                        ([lower(state.timer.packageList{pIndex}) ...
                        'OnList'])(pos)
                    valid=1;
                end
            end
        end
    end


%%
while ~isValid 
    passedEnd=0;
 %   [state.cycle.currentCyclePosition state.cycle.repeatsDone]
    if state.cycle.randomize % are we randomizing
        if (state.internal.randomPosition > length(state.internal.randomPositionsList)) % are we passed the end
            state.internal.randomPosition=1;
            setupCycleRandomList;
            passedEnd=1;
        end
    else % we are not randomizine
        if state.cycle.currentCyclePosition <= length(state.cycle.delayList) && ...
                state.cycle.repeatsDone>=state.cycle.repeatsList(state.cycle.currentCyclePosition) % are the repeats done
            state.cycle.currentCyclePosition = state.cycle.currentCyclePosition + 1; % yes, advance
            state.cycle.repeatsDone=0;
        end
        
        if state.cycle.currentCyclePosition > length(state.cycle.delayList) % are we passed the end
            state.cycle.currentCyclePosition=1;
            state.cycle.repeatsDone=0;
            passedEnd=1;
        end
    end
    
    if passedEnd % we came to the end of the cycle
        if state.cycle.endAfterCycle
            if isempty(state.cycle.nextCycle)
                testPosition=-1;
                disp('*** Done with cycle. Ending loop');
                return
            else
                loadCycle(state.cycle.nextCycle);
                disp(['*** Loading next cycle ' state.cycle.nextCycle]);
                if state.cycle.randomize
                    setupCycleRandomList;
                    startingPosition=state.internal.randomPosition;
                else
                    state.cycle.currentCyclePosition=1;
                    startingPosition=state.cycle.currentCyclePosition;
                end
            end
        end
        disp('*** New cycle started. ***');
    end
    
    if state.cycle.randomize
        testPosition=state.internal.randomPositionsList(state.internal.randomPosition);
    else
        testPosition=state.cycle.currentCyclePosition;
    end
    
    isValid=isPositionValue(testPosition); % check if the current candidate position if valid
    
    if ~isValid % still nothing valid
        if ~first && testPosition==startingPosition % there is no valid position and we gone around the cycle
            setStatusString('INVALID CYCLE');
            error('findValidCyclePosition: no valid cycle position found');
        else % advance to the next test
            if state.cycle.randomize
                state.internal.randomPosition = state.internal.randomPosition + 1;
            else
                state.cycle.currentCyclePosition = state.cycle.currentCyclePosition + 1;
                state.cycle.repeatsDone=0;                
            end
        end
    end
end

if isValid
    if state.cycle.randomize    
        state.cycle.currentCyclePosition=state.internal.randomPositionsList(state.internal.randomPosition);
        updateGuiByGlobal('state.cycle.currentCyclePosition');
        if state.internal.randomPosition>1
            state.cycle.repeatsDone=length(find(state.internal.randomPositionsList(1:state.internal.randomPosition-1)==state.cycle.currentCyclePosition));
        else
            state.cycle.repeatsDone=0;
        end
    end
end

updateGuiByGlobal('state.cycle.currentCyclePosition');
updateGuiByGlobal('state.cycle.repeatsDone');

end
