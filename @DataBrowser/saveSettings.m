function saveSettings(self)
%SAVESETTINGS  Saves current settings
    settings = self.settings2struct(); %#ok<NASGU>
    if ~exist(self.SettingsDir,'dir')
        fprintf('Trying to generate directory %s... ',  self.SettingsDir);
        try
            mkdir(self.SettingsDir);
            fprintf('OK.\n');
        catch
            fprintf('Failed.\n');
            % Tried to generate default dir
            error('DataBrowser:CouldNotCreateDirectory','Failed to create directory %s. Could not save settings.', self.SettingsDir);
        end
    end
    fn = [self.SettingsDir filesep() self.SETTINGSFILENAME];
    try
        save(fn, 'settings');
    catch
        error('DataBrowser:CouldNotSaveFile','Could not save settings file %s', fn);
    end