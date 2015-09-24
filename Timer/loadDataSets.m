function [DataSet,pname,fname] = loadDataSets(pname,fname)
	global state 
	
    if isempty(fname)
        if isempty(pname)
            pname=pwd;
        end
        if ~isempty(state.userSettingsPath)
            try
                cd(state.userSettingsPath);
            catch
            end
        end
        [fname, pname]=uigetfile(fullfile(pname,fname), 'Load Data Set file');
    end
    
    if ~isnumeric(fname)
        periods=findstr(fname, '.');
        if any(periods)
            fname=fname(1:periods(1)-1);
        end
        load(fullfile(pname,[fname,'.mat']))
    end
    
    