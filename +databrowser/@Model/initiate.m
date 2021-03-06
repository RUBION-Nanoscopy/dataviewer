function initiate(self, filename, datadirs, icondir)
    self.IsReady = false;
    self.CurrentMsg = 'Initiating Data';
    self.TotalFraction = 0;
    self.directories = datadirs;
    self.icondir = icondir;
    self.CacheFilename = filename;
    
    self.StartupSteps.addStep('loadDatareaders','Looking for known file extensions',...
        'Callbacks', {@self.lookupDatareaders} ...
    );
    self.StartupSteps.addStep('loadCache','Loading cached data',...
        'Callbacks', {@self.loadCache} ...
    );
    self.StartupSteps.addLoopStep('scanDirectories', 'Scanning observed directories', ...
        @()(1:numel(self.DataReaders)), @(cnt, obj, varargin)(self.scanDirectories(cnt))...
    );

    self.StartupSteps.addLoopStep('initCache','Initializing cached data',...
        @()(1:numel(self.Cache)), ...
        @(cnt, obj, varargin)(self.initializeCache(cnt)) ...
    );

    

    self.StartupSteps.addLoopStep('generatePreviews', 'Generating Previews', ...
        @()(1:numel(self.Files)), @(cnt, obj, varargin)(self.generatePreview(cnt))...
    );
    self.StartupSteps.callAllSteps();
    self.IsReady = true;
    