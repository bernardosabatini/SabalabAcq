function seeGUI(GUI)
% makes a gui visible.  expects string with name of gui
if ishandle(GUI)
    set(GUI, 'Visible', 'on');
    if strcmp(get(GUI, 'Type'), 'figure')
        figure(GUI);
    end
else
	evalin('base', ['set(' GUI ', ''Visible'', ''on'')']);
    if evalin('base', ['strcmp(get(' GUI ', ''Type''), ''figure'')'])
    	evalin('base', ['figure(' GUI ')']);
    end
end

	
