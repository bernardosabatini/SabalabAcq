function deviceIndex = timerDevice_getIndex(deviceID)
% given a board index, returns the device ID related to id

    global state
    deviceIndex=[];
    for counter=1:length(state.devices)
        if strcmp(deviceID, state.devices(counter).ID)
            deviceIndex=counter;
            return 
        end
    end
end
    



