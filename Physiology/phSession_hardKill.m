function phSession_hardKill
%phSession_hardKill Extreme need function to hard kill the data acquisition
% devices
    disp(' *** DOING PHYS HARD KILL - Be PATIENT');
    global physInputSession physOutputSession
    delete(physInputSession)
    delete(physOutputSession)
    physOutputSession=[];
    global physInputSession physOutputSession
    phSession_buildInput;
    phSession_buildOutput(1);
	timerCallPackageFunctions('Abort');
end

