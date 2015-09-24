function  timerApplyCyclePosition_Physiology
% look at what need to be done at this cycle position and get the
% physiology package ready to do it

    global state

    timerSetActiveStatus('Physiology', state.cycle.physiologyOnList(state.cycle.currentCyclePosition));

    % compare required output channels to those previsouly used to
    % understand if the output session needs to be rebuilt

    state.cycle.pulsesToUse=[...
        state.cycle.da0List(state.cycle.currentCyclePosition)...
        state.cycle.da1List(state.cycle.currentCyclePosition)...
        ];
    
    state.cycle.auxPulsesToUse=[...
        state.cycle.aux4List(state.cycle.currentCyclePosition) ...
        state.cycle.aux5List(state.cycle.currentCyclePosition) ...
        state.cycle.aux6List(state.cycle.currentCyclePosition) ...
        state.cycle.aux7List(state.cycle.currentCyclePosition)...
        ];

    if state.cycle.physiologyOnList(state.cycle.currentCyclePosition) % physiology is on

        if length(state.cycle.lastAuxPulsesUsed)~=4
            state.cycle.lastAuxPulsesUsed=[0 0 0 0];
        end

        if length(state.cycle.lastPulsesUsed)~=2
            state.cycle.lastPulsesUsed=[0 0];
        end

        if any(state.cycle.lastPulsesUsed)~=any(state.cycle.pulsesToUse)
            state.phys.internal.needNewOutputChannels=1;
        end

        if any(state.cycle.pulsesToUse~=state.cycle.lastPulsesUsed)
            state.phys.internal.needNewOutputData=1;
        end

        if state.phys.daq.auxOutputBoard
            if any(state.cycle.lastAuxPulsesUsed)~=any(state.cycle.auxPulsesToUse)
                state.phys.internal.needNewOutputChannels=1;
            end
            if any(state.cycle.lastAuxPulsesUsed~=state.cycle.auxPulsesToUse)
                state.phys.internal.needNewOutputData=1;
            end
        end
    end
    
    if state.phys.internal.needNewOutputChannels
        phSession_buildOutput;
        state.phys.internal.needNewOutputChannels=0;
        state.phys.internal.needNewOutputData=1;
    end

    state.cycle.pulseToUse0=state.cycle.pulsesToUse(1);
    state.cycle.pulseToUse1=state.cycle.pulsesToUse(2);
    updateGuiByGlobal('state.cycle.pulseToUse0');
    updateGuiByGlobal('state.cycle.pulseToUse1');




