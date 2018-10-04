function timerKeyPressFunction
global state gh

% genericKeyPressFcn.m*****
% Function that looks at the last key pressed and executes an appropriate function.
% First gets all the current character from all the GUIs
%
% Written By: Thomas Pologruto and Bernardo Sabatini
% Cold Spring Harbor Labs
% January 30, 2001

val = double(get(gcbo,'CurrentCharacter'));
if length(val) ~= 1
    return
end

if (val==13) || (val==74) ||(val==106) % J or Ctrl J
	setStatusString('Type Note');
    setfocus(gh.notebook.newEntry);
end


