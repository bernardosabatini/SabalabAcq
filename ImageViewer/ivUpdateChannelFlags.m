function ivUpdateChannelFlags
	global state
		for counter=[1:state.imageViewer.maxChannels 11:(10+state.imageViewer.maxChannels)]
			eval(['state.imageViewer.ana' num2str(counter) '=state.imageViewer.anaChannels(counter);']);
			updateGuiByGlobal(['state.imageViewer.ana' num2str(counter)]);
			eval(['state.imageViewer.anaMax' num2str(counter) '=state.imageViewer.anaMaxChannels(counter);']);
			updateGuiByGlobal(['state.imageViewer.anaMax' num2str(counter)]);
			eval(['state.imageViewer.view' num2str(counter) '=state.imageViewer.viewChannels(counter);']);
			updateGuiByGlobal(['state.imageViewer.view' num2str(counter)]);
			eval(['state.imageViewer.maxView' num2str(counter) '=state.imageViewer.maxViewChannels(counter);']);
			updateGuiByGlobal(['state.imageViewer.maxView' num2str(counter)]);
		end
