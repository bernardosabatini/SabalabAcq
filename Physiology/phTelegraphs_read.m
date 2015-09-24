function phTelegraphs_read
	global state

	readAxon=0;
	for counter=0:1
		switch state.phys.settings.(['channelType' num2str(counter)])
		case 2
			if ~readAxon
				phTelegraphs_read200B;
				readAxon=1;
			end
		case 3
			phTelegraphs_readMulticlamp(counter);
		end
	end
	phSetChannelGains
	