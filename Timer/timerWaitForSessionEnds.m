 function timerWaitForSessionEnds(packages)
	
	ready=0;
	attemptCounter=0;
	while ~ready
        if nargin<1
            status=timerCallPackageFunctions('IsSessionDone');
        else
            status=timerCallPackageFunctions('IsSessionDone', packages);
        end
        
		if any(status==0)
			attemptCounter=attemptCounter+1;
		%	disp('timerTrigger: Timer packages sessions still running');
			pause(0.05);
		else
			ready=1;
		end
	end

	
	