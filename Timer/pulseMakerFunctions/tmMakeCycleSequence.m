function tmMakeCycleSequence(templatePattern, startingNumber, varargin)
    
    global state

    nParams=length(varargin);
    if nParams~=floor(nParams)
        error('Odd number of parameters passed in')
    end

    maxLength=1;
    if nParams>0
        for vCounter=2:2:nParams
            maxLength=max(maxLength, length(varargin{vCounter}));
        end
        for vCounter=2:2:nParams
            if ~isfield(state.cycle, [varargin{vCounter-1} 'List']) 
                error([varargin{vCounter-1} ' is not a cycle parameter']);
            end
            ll=length(varargin{vCounter});
            if ll~=1 && ll~=maxLength
                error([' Parameter values ' varargin{vCounter-1} ' has length ' num2str(ll) ...
                    ' which is not 1 and not the max entry of ' num2str(maxLength)]);
            end
            if ll==1
                varargin{vCounter}=repmat(varargin{vCounter}, 1, maxLength);
            end
        end
    end
    
    disp(['*** Copying from cycle position #' num2str(templatePattern) ...
        ' to a ' num2str(maxLength) ' positions starting at ' ...
        num2str(startingNumber)]);

    for pCounter=1:maxLength
        pNum=startingNumber+pCounter-1;
        tmCopyCyclePosition(templatePattern, pNum);
        oString=[' Cycle position #' num2str(pNum) ': '];
        for vCounter=1:2:nParams
            state.cycle.([varargin{vCounter} 'List'])(pNum)=...
                varargin{vCounter+1}(pCounter);
            oString=[oString ' ' varargin{vCounter} '=' num2str(varargin{vCounter+1}(pCounter))];
        end
        disp(oString);
        makePulsePattern(pNum);        
        if state.cycle.displayCyclePosition==pNum
            timerCycle_setDisplayPosition(state.cycle.displayCyclePosition);
        end
    end

       


