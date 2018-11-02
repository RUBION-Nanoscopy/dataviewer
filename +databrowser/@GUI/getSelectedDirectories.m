function dirs = getSelectedDirectories( self, dataDirs, iconsDir, saveDir )
% GETSELECTEDDIRECTORIES  Opens the directory selection
    if ~iscell(dataDirs)
        dataDirs={dataDirs};
    end
    self.SettingsFields.ScanDirSelector.Value = dataDirs;
    self.SettingsFields.IconsDirSelector.Value = iconsDir;
    self.SettingsFields.SaveDirSelector.Value = saveDir;
    self.Settings.CloseRequestFcn = @(~,~)set(self.Settings,'Visible', 'off');
    self.Settings.Visible = 'on';
    uiwait(self.Settings);
    self.Settings.Visible = 'off';
    dirs = struct(...
        'DataDirs', self.SettingsFields.ScanDirSelector.Value,...
        'IconsDir', self.SettingsFields.IconsDirSelector.Value,...
        'SaveDir', self.SettingsFields.SaveDirSelector.Value ...
    );