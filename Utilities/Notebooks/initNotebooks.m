function initNotebooks
	global state gh

	gh.notebook=guihandles(notebook);
	openini('notebook.ini');
	state.notebook.notebookText={''};
	