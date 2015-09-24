%% Merge the advancedCycleGUI windows
function timerCycle_mergeWindow(figName, packageName)

    global gh

    aCG = gh.advancedCycleGui; % Open Cycle Definition GUI Window
    aCG_handle = aCG.figure1;
    S1 = get(aCG.figure1,'Position'); % Existing window Size

    NewWindHandle = openfig([figName,'.fig'],'reuse','invisible');
    S2 = get(NewWindHandle,'Position'); % New window Size
    Nh = max([S1(3),S2(3)]); Nv = S1(4)+S2(4);
    Y = Nv-S1(4);
    
    if nargin==2
        c=get(get(NewWindHandle, 'Children'), 'Children');
        setUserDataField(c, 'Package', packageName);
    end
    
    set(aCG_handle,'Position',[S1(1) S1(2)  Nh   Nv]); % Resize Current window
    Pannel_handles = allchild(aCG_handle);
    for f=size(Pannel_handles,1):-1:1
        Hposition=get(Pannel_handles(f),'Position');
        Hposition(2) = Hposition(2)+Y; % Vertical Shift
        set(Pannel_handles(f),'Position',Hposition(:)); % Move Pannels
    end

    set(allchild(NewWindHandle),'Parent',aCG_handle); % Change Parent 

% % Add New Pannel
% PS2 = get(allchild(NewWindHandle),'Position'); % Panel Size
% uipanel(aCG_handle,'Units','characters','Position',[PS2(1) PS2(2) PS2(3) PS2(4)]);
% Pannel_handles = allchild(aCG_handle);
% 
% CopyControls(NewWindHandle,aCG,Pannel_handles(1)); % Copy Controls
gh.advancedCycleGui=guihandles(advancedCycleGui);


