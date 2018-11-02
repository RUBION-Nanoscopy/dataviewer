function composeSettings(self)
% COMPOSESETTINGS  Composes the settings figure
    % save old screen units...
    oldunits = get(0,'units');
    % set to pixels
    set(0,'units','pixels');

    screensize = get(0,'screensize');
    
    % Splash screen size should be 1/3 of width/height
    w = round(screensize(3)/3);
    h = 368;%round(screensize(4)/3);
    self.Settings.Position = [...
            (screensize(3)-w)/2, ...
            (screensize(4)-h)/2, ...
            w h];
    vb = uix.VBox(...
        'Parent', self.Settings ...
    );
    head = uix.Text(...
        'Parent', vb, ...
        'String', 'Select your data directories', ...
        'FontSize',16 ...
    );
    scanDirPanel = uix.Panel(...
        'Parent', vb, ...
        'Title', 'Data directories' ...
    );
    self.SettingsFields.ScanDirSelector = uixaddons.MultiDirSelector(...
        'Parent', scanDirPanel);
    
    
    saveDirPanel = uix.Panel(...
        'Parent',vb, ...
        'Title', 'Directory for the cache file' ...
    );
    self.SettingsFields.SaveDirSelector = uixaddons.DirSelector(...
        'Parent', saveDirPanel);
    
    iconsDirPanel = uix.Panel(...
        'Parent',vb, ...
        'Title', 'Directory for the icon files' ...
    );
    self.SettingsFields.IconsDirSelector = uixaddons.DirSelector(...
        'Parent', iconsDirPanel);
    
        
    buttons = uix.HButtonBox(...
        'Parent',vb,...
        'ButtonSize',[96,32], ...
        'HorizontalAlignment','right' ...
    );
    okayBtn = uicontrol(...
        buttons, ...
        'Callback', @(~,~)(uiresume), ...
        'String','OK' ...
    );
    cancelBtn = uicontrol(...
        buttons, ...
        'Callback', @(~,~)(uiresume), ...
        'String','Cancel' ....
    );
    vb.Heights = [32,-1, 48, 48, 36];
    % restore old screen units
    set(0,'units',oldunits);