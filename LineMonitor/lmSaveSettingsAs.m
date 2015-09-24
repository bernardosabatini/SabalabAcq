function lmSaveSettingsAs(fullName)
    global state
    
    if nargin<1 || isempty(state.lm.currentSettingsFile)
        [fName, pName] = uiputfile('*.mat', 'Save as');
        if isempty(fName) || isnumeric(fName)
            setStatusString('Save canceled')
            return
        end
        fullName=fullfile(pName, fName);
    end
    
    save(fullName, '-struct', 'state', 'lm');
    setStatusString('Settings saved')
    state.lm.currentSettingsFile=fullName;