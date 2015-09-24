function timerSessionWait_Physiology
    global physInputSession physOutputSession
    
    if physInputSession.IsContinuous    
        return
    end
    
    if physInputSession.IsRunning
    	setPhysStatusString('waiting for input');
        physInputSession.wait();
    end
    
    if physOutputSession.IsRunning
    	setPhysStatusString('waiting for output');
        physOutputSession.wait();        
    end
    
    physInputSession.release();
    physOutputSession.release();
 	timerRegisterPackageDone('Physiology');

end

