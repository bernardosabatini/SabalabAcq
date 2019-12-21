function out=timerIsSessionDone_Physiology
    out=0;
    global physInputSession physOutputSession state

    if physInputSession.IsContinuous    
        return
    end

    if state.timer.abort
        out=1;
        return
    end
    
    if physInputSession.IsRunning
        return
    else
        if physOutputSession.IsRunning
            return
        else
            out=1;
        end
        physInputSession.stop();
        physOutputSession.stop();
        physInputSession.release();
        physOutputSession.release();
    end
    setPhysStatusString('Physiology done');
end

