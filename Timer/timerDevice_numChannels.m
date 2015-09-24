function nChans=timerDevice_numChannels(deviceID, channelType)
% Extracts the number of  channels for a particular device

    global state

    nChans=0;
    
    deviceIndex=timerDevice_getIndex(deviceID);

    if isempty(deviceIndex)
        return
    end
    
    for subCounter=1:length(state.devices(deviceIndex).Subsystems)
        if strcmp(...
                state.devices(deviceIndex).Subsystems(subCounter).SubsystemType,...
                channelType...
                )
            nChans=state.devices(deviceIndex).Subsystems(subCounter).NumberOfChannelsAvailable;
            return
        end
    end

