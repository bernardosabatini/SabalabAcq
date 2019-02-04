function timerWait_Physiology
	global state
	
% 	if timerGetPackageStatus('Physiology')
% 		return
% 	end
	
	try
		phTelegraphs_read
		phBaseline_read
		updateMinInCell
    catch
		disp(['timerWait_Physiology: ' lasterr]);
    end