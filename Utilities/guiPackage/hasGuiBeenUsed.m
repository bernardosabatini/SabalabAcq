function out=hasGuiBeenUsed(handle)
	out=hasUserDataField(handle, 'LastValid');
	