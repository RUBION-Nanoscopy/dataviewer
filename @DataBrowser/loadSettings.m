function loadSettings(self)
%LOADSETTINGS   Loads the settings file
    failed = false;
    fn = [self.SettingsDir filesep() self.SETTINGSFILENAME];
    try
        ld = load(fn, 'settings');
    catch 
        failed = true;
        warning('DataBrowser:CouldNotLoadFile', 'Could not load the settings file %s. Assuming defaults.', fn);
    end
    
    if ~failed
        self.SaveDir_= ld.settings.SaveDir;
        self.IconsDir_ = ld.settings.IconsDir;
        self.DataDirectories = ld.settings.DataDirectories;
    end