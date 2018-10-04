function timerSessionWait_Physiology
    global physInputSession physOutputSession
    
    if physInputSession.IsContinuous    
        return
    end
    
    if physInputSession.IsRunning
    	setPhysStatusString('waiting for input');
        physInputSession.wait;
    end
    
%     if physOutputSession.IsRunning
%     	setPhysStatusString('waiting for output');
%         physOutputSession.wait;
%     end

    more=1;
    while more
        if physOutputSession.IsRunning
            %         physOutputSession.ScansQueued
            setPhysStatusString('waiting for output');
            if physOutputSession.ScansQueued==0
                more=0;
                physOutputSession.stop();
            else
                pause(.01);
            end
        else
            more=0;
        end
    end
    setPhysStatusString('Physiology done');
    
    physInputSession.release();
    physOutputSession.release();
    timerRegisterPackageDone('Physiology');

end

