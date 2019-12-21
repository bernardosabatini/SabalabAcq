function timerSession_resolveTriggers
% timerSession_resolveTriggers Decides which package will be the master
%

    global state

    triggerPackages=timerGetActiveStatus.*state.timer.triggerPackages;

    state.timer.oldTriggerPackage=state.timer.triggerPackage;
    state.timer.oldTriggerLine=state.timer.triggerLine;

    state.timer.triggerChanged=0;

    state.timer.triggerLine='';
    state.timer.triggerPackage='';

    packs=find(triggerPackages);

    if ~isempty(packs)
        funcName=['timerTriggerLine_' state.timer.packageList{packs(1)}];
        if exist(funcName, 'file')==2
            %          disp(['CALLING:  ' funcName]);
            state.timer.triggerLine=eval(funcName);
            state.timer.triggerPackage=state.timer.packageList{packs(1)};
        else
            error(['Attempt to give trigger to ' ...
                state.timer.packageList{packs(1)} ...
                ' failed due to lack of Trigger package function']);
        end

        if ~strcmp(state.timer.oldTriggerPackage, state.timer.triggerPackage) || ...
                ~strcmp(state.timer.oldTriggerLine, state.timer.triggerLine) || ...
                ~isequal(triggerPackages, state.timer.oldTriggerPackages)
            state.timer.triggerChanged=1;

            timerCallPackageFunctions(...
                'SetTriggerMaster', packs(1));
            for counter=2:length(packs)
                timerCallPackageFunctions(...
                    'SetTriggerSlave', packs(counter));
            end
        end
    else
        disp('timerSession_resolveTriggers: No trigger packages available');
    end
    state.timer.oldTriggerPackages=triggerPackages;
    
