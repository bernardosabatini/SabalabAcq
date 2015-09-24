function timerMainLoop
	global state 
    
	state.cycle.loopingStatus=1; 	% a loop
    state.timer.abort=0;

	setStatusString('Looping...');
	timerCallPackageFunctions('FirstSetup');
		
    done=0;
    
    while ~done
        change=0;
        recoveredFromPause=0;
        if state.cycle.loopingStatus==2	% we're going in after a pause
            state.cycle.loopingStatus=1;
            recoveredFromPause=1;
        end

        if needToGetOut
            return
        end	

        nextPosition=findValidCyclePosition;
        
        if nextPosition==-1 % flag set to indicate that the cycle has ended and the user does not want to restart if
            state.timer.abort=1;
    		timerCallPackageFunctions('Abort');
            return
        elseif nextPosition==0 % flag indicates that the user wants to continue but there is no valid cycle position to use
            setStatusString('BAD CYCLE');
            error('mainLoop: Unable to find valid cycle position');
        end
        
        timerCycle_applyPosition;

        if needToGetOut
            return
        end	

        state.cycle.loopingStatus=1;

        if (state.internal.firstTimeThroughLoop==0) || recoveredFromPause
            state.internal.secondsCounter=floor(state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime));
        else
            state.internal.triggerTime=clock;
            state.internal.secondsCounter=state.internal.lastTimeDelay;
        end

        updateGuiByGlobal('state.internal.secondsCounter');

        % load daq engine % here get dacq ready for trigger
        if (state.internal.firstTimeThroughLoop==0) || state.acq.externalTrigger
            setStatusString('Counting down...');

            if etime(clock,state.internal.triggerTime)>(state.internal.lastTimeDelay)
                setStatusString('DELAY TOO SHORT!');
                beep;
            end

            if etime(clock,state.internal.triggerTime) >= (state.internal.lastTimeDelay-10)
                setStatusString('Setting up packages...');
                timerCallPackageFunctions('Setup');
                timerSession_resolveTriggers;
%               gotoCycleStagePosition(state.internal.firstTimeThroughLoop);
                setupDone=1;
            else
                setupDone=0;
            end

            while etime(clock,state.internal.triggerTime) <(state.internal.lastTimeDelay-1)
                if needToGetOut
                    return
                end	

                if (etime(clock,state.internal.triggerTime) >= (state.internal.lastTimeDelay-10)) && ~setupDone
                    setStatusString('Setting up packages...');
                    timerCallPackageFunctions('Setup');
                    timerSession_resolveTriggers;
                    setupDone=1;
                end
                old=etime(clock,state.internal.triggerTime);

                timerCallPackageFunctions('Wait');

                while floor(etime(clock,state.internal.triggerTime))<old
                    pause(0.01);
                    if needToGetOut
                        return
                    end
                end
                state.internal.secondsCounter=round(state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime));
                updateGuiByGlobal('state.internal.secondsCounter');
                pause(0.01);
            end

            if needToGetOut
                return
            end
            state.internal.secondsCounter=0;

            timerCallPackageFunctions('Start');

            if state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime)-state.internal.timingDelay>0
                pause(state.internal.lastTimeDelay-etime(clock,state.internal.triggerTime)-state.internal.timingDelay) % 0.05 is 
            end
        else
            if ~recoveredFromPause
                setStatusString('Setting up packages...');
                timerCallPackageFunctions('Setup');
                timerSession_resolveTriggers;
%                gotoCycleStagePosition(state.internal.firstTimeThroughLoop);
            end
            if needToGetOut
                return
            end	
            timerCallPackageFunctions('Start');

            state.internal.firstTimeThroughLoop=0;
        end

        if state.timer.abort
            return
        end

        timerCallPackageFunctions('ReadyForTrigger');		

        setStatusString('Acquiring...');

        if ~state.acq.externalTrigger
            timerTrigger;
        else
            setStatusString('Waiting for trigger...');
            disp(['Waiting for trigger at ' clockToString(clock) '. ']);
        end		

        timerCallPackageFunctions('SessionWait');	

        updateGuiByGlobal('state.internal.secondsCounter');

        state.cycle.repeatsDone=state.cycle.repeatsDone+1;
        updateGuiByGlobal('state.cycle.repeatsDone');

        if state.cycle.randomize
            state.internal.randomPosition=state.internal.randomPosition+1;
        end
    end
	
	
	
function out=needToGetOut
    global state
    out=0;
    if state.timer.abort
        out=1;
    elseif timerPausedStatus
        state.cycle.loopingStatus=2;
        setStatusString('LOOP PAUSED');
        out=1;
    end

    
