function timerSession_removeTriggerConnections(session)
    
    nConnections=length(session.Connections);
    
    triggerIndices=[];
    
    triggerType=enumeration('daq.ni.TriggerConnectionType');
    
    for cIndex=nConnections:-1:1
        if session.Connections(cIndex).Type==triggerType(1)
            triggerIndices(end+1)=cIndex;
        end
    end
    
    if isempty(triggerIndices)
        return
    end
    
    for cIndex=triggerIndices
        session.removeConnection(cIndex);
    end
    
    