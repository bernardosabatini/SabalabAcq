function hideGUI(GUI)
if ishandle(GUI)
    set(GUI, 'Visible', 'off');
else
	evalin('base', ['set(' GUI ', ''Visible'', ''off'')']);
end
