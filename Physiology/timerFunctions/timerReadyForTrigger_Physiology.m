function status=timerReadyForTrigger_Physiology
	global state physOutputDevice physAuxOutputDevice
		
	status=1;	% good to do
%    	if (~isempty(state.phys.daq.auxOutputBoardIndex)) && any(state.cycle.lastAuxPulsesUsed) 
% 		if state.phys.internal.forceTrigger || ~state.cycle.imagingOnList(state.cycle.currentCyclePosition)
% 			if strcmp(get(physAuxOutputDevice, 'Running'), 'Off')
% 				status=0; % not ready
% 				disp('timerReadyForTrigger_Physiology: auxOutputDevice not ready');
% 			end
% 		end			
% 	end	
% 
% 	if ~state.phys.internal.runningMode && any(state.cycle.pulsesToUse)
% 		if strcmp(get(physOutputDevice, 'Running'), 'Off')	
% 			status=0; % not ready
% 			disp('timerReadyForTrigger_Physiology: outputDevice not ready');
% 		end
% 	end


