function [pname,fname]=saveDataSets(DataSet,pname,fname)
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
        [fname, pname]=uiputfile(fullfile(pname,fname), 'Save Data Set file');
    end
    DataSet{4}=pname; DataSet{5}=fname; 
    if ~isnumeric(fname)
        periods=findstr(fname, '.');
        if any(periods)
            fname=fname(1:periods(1)-1);
        end
        save(fullfile(pname,[fname,'.mat']),'DataSet')
    end
    
    