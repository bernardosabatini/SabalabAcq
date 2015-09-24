function phStreaming_readFile(fileName)
	global state

    if (nargin<1) || isempty(fileName)
		[fname, pname]=uigetfile('*.daq', 'Choose data log file to load');
		if isempty(fname) || isnumeric(fname)
			return
		end
		fileName=fullfile(pname, fname);
    end
	
    global physData
    
    nChan=length(state.phys.internal.acquiredChannels);
    [FID, msg]=fopen(fileName, 'r');
    physData=fread(FID, 'float');
    fclose(FID);
    physData=reshape(physData, nChan, size(physData, 1)/nChan);

    for counter=1:nChan
        channel=state.phys.internal.acquiredChannels(counter);			% what DA #

        setWave(['dataWave' num2str(channel)], ...
            'data', physData(counter,:)...
            );
    end	
    
	