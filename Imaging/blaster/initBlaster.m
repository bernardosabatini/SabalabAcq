function initBlaster
% initBlaser % initializes the guis and variables necessary for the blaster

% the blaster info is stored in state.blaster.allConfigs
% this is cell array 
% each line of the cell array represents a single blaster configuration
% the rows of the cell array are as follows:
% 1 : string containing the name of the blaster configuration stored on
% that line
% 2 : an array that contains all of the "lines" of the configuration
% each row of the array corresponds to one blaster configuration line
% the columns of each row of the array are:
%	1 : what blaster position to use
%	2 : what pulse pattern to use 
%	3 : the blaster pulse width 
%	4 : the blaster pulse power channel 1
%	5 : the blaster pulse power channel 2
%	6 : boolean : should the blaster pulse position be extracted from the
%	tiler?

	global state gh

	gh.blaster=guihandles(blaster);		
	initGUIs('newBlaster.ini');

	state.blaster.allConfigs={'Default', [1 0 .5 20 20 0]};
	makeBlasterConfigMenu;
	

	state.blaster.paramList = {...
			'active' ...
			'prePark' ...
			'widthFromPattern' ...
			'powerFromPattern' ...
			'screenCoord' ...
			'allConfigs' ...
			'currentConfig' ...
			'XList' ...
			'YList' ...
			'indexList' ...
			'indexXList' ...
			'indexYList' ...
		};