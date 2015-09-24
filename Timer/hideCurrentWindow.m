function hideCurrentWindow
	try
		set(gcf, 'Visible', 'off');
	catch
		disp('hideCurrentWindow: MATLAB must be closing.  Killing window');
		delete(gcf);
	end