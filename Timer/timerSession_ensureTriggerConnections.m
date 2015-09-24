function madeChanges=timerSession_ensureTriggerConnections(session, driver, line)
    
    nConnections=length(session.Connections);
    
    triggerIndices=[];
    
    triggerType=enumeration('daq.ni.TriggerConnectionType');
    
    for cIndex=nConnections:-1:1
        if session.Connections(cIndex).Type==triggerType(1)
            triggerIndices(end+1)=cIndex;
        end
    end
    
    foundCorrect=0;
    
    madeChanges=0;
    if driver % it should be the source of the trigger
        for cIndex=triggerIndices
            foundCorrect=0;
            if ~foundCorrect && ...
                    strcmp(session.Connections(cIndex).Destination, 'External') && ...
                    strcmp(session.Connections(cIndex).Source, line)
                foundCorrect=1;
            else
                session.removeConnection(cIndex);
                madeChanges=1;
            end
        end
        
        if ~foundCorrect
            session.addTriggerConnection(...
                line, ...
                'External', ...
                'StartTrigger');
            madeChanges=1;
        end
    else
        f=strfind(line, '/');
        if ~isempty(f)
            line=line(f+1:end);
        end
        
        channelDeviceIDs={};
        
        % get all the devices associated with channels
        for counter=1:length(session.Channels)
            deviceID=session.Channels(counter).Device.ID;
            if ~any(strcmp(deviceID, channelDeviceIDs))
                channelDeviceIDs{end+1}=deviceID;
            end
        end
        
        hasConnection=zeros(1, length(channelDeviceIDs));
        
        for cIndex=triggerIndices
            isItOK=0;
            if strcmp(session.Connections(cIndex).Source, 'External')
                f=strfind(session.Connections(cIndex).Destination, '/');
                deviceID=session.Connections(cIndex).Destination(1:f-1);
                index=find(strcmp(deviceID, channelDeviceIDs));
                if length(index)>1
                    error('bizare... multiple triggers to same board');
                elseif isempty(index)
                    disp('deleting connection to board that is not in channel list');
                    session.removeConnection(cIndex);
                    madeChanges=1;
                else % there is a valid board.  Is it with the right line?
                    existingLine=session.Connections(cIndex).Destination(f+1:end);
                    if strcmp(existingLine, line)
                        hasConnection(index)=1;
                    else
                        session.removeConnection(cIndex);
                        madeChanges=1;
                        disp('changing')
                        disp([existingLine ' to ' line]);
                    end
                end
            else
                session.removeConnection(cIndex);
                madeChanges=1;
            end
        end
        
        for index=find(hasConnection==0)
            session.addTriggerConnection(...
                'External', ...
                [channelDeviceIDs{index} '/' line], ...
                'StartTrigger');
        end     
    end
    
    