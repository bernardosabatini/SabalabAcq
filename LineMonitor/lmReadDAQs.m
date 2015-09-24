function lmReadDAQs
	global state lmSession

	if ~state.lm.lineMonitorActive || ~state.hasDevices
		return
    end

    data=lmSession.inputSingleScan();
    lmSession.release

    activeLines=find(state.lm.activeLines);
    
    for lineCounter=1:length(activeLines)
        lineNumber=activeLines(lineCounter);
        if state.lm.(['linear' num2str(lineNumber)])
            % it's linear, let's transform
            val=state.lm.(['linearOffset' num2str(lineNumber)]) + ...
                data(lineCounter)*state.lm.(['linearSlope' num2str(lineNumber)]);
        elseif ~isempty(state.lm.(['transformFunction' num2str(lineNumber)]))
            val=eval([state.lm.(['transformFunction' num2str(lineNumber)]) ...
                '(data(lineNumber))']);
        else
            val=data(lineCounter);
        end
        sigDig=round(state.lm.(['sigDigits' num2str(lineNumber)]));
        if sigDig>=0
            sigDig=10^sigDig;
            eval(['state.lm.paramValue' num2str(lineNumber) '=round(val*sigDig)/sigDig;']);
        else
            eval(['state.lm.paramValue' num2str(lineNumber) '=val;']);
        end
        updateGuiByGlobal(['state.lm.paramValue' num2str(lineNumber)]);
    end
    
