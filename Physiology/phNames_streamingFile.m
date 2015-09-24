function out=phNames_streamingFile(counter)
	global state
	
    if state.phys.internal.runningMode
        out=fullfile(state.files.savePath, 'liveLogFile.daq');
    else
        if nargin<1
            counter=state.files.fileCounter;
        end

        if isnumeric(counter)
            counter=num2str(counter);
        end
        out=fullfile(state.files.savePath, ['ContAcqLog_' counter '.daq']);
    end
