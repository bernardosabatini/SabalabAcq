function timerMakeAnalysisFunctionMenu
	
	global state gh
	
	children=get(gh.timerMainControls.Analysis, 'Children');
	
	if ~isempty(children)
		delete(children);
	end
	
	uimenu(gh.timerMainControls.Analysis, 'Label', 'Set Analysis Function Path...', 'Enable', 'on', ...
		'Callback', 'timerSetAnalysisFunctionPath');
    
	if ~isempty(state.timer.analysisFunctionPath)
		flist=dir([state.timer.analysisFunctionPath '\*.m']);
				
		for counter=1:length(flist)	
			period=find(flist(counter).name=='.');
			fname=flist(counter).name(1:period-1);
			if counter==1
				uimenu(gh.timerMainControls.Analysis, ...
					'Label', fname, 'Callback', 'timerSelectFunctionFromMenu' ...
					, 'Separator', 'on');
			else
				uimenu(gh.timerMainControls.Analysis, 'Label', fname, 'Callback', 'timerSelectFunctionFromMenu');
			end
		end
	else
		uimenu(gh.timerMainControls.Analysis, 'Label', 'Set Analysis Function Path...', 'Enable', 'on', ...
			'Callback', 'timerSetAnalysisFunctionPath');
	end		