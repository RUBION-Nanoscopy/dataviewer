classdef DataBrowser < databrowser.Dependencies 
    %DATABROWSER  Show previews of data in observed directories
    
    % I'm trying to follow a MVC scheme here in this code. This class is
    % the controller. View and Model are in the (currently public)
    % properties View and Model. 
    
    properties (Constant, Hidden)
        major_version = 0;
        minor_version = 1;
        version_comment = 'development code';
        TITLE = 'Nanoscopy Lab Data Browser';
        DEFAULTSETTINGSDIR = 'databrowser/settings';
        DEFAULTICONSDIR = 'databrowser/previews';
        DEFAULTSAVEDIR = 'databrowser/save';
        
        SETTINGSFILENAME = 'settings.mat';
        SAVEFILENAME = 'cache.mat';
    end
      
    properties ( Access = public )
        View % The View class for the main data
        Model % The main data
        
        SettingsView % View for the settings
        SettingsModel % Model for Settings
        
        DataDirectories = {};
    end
    
    properties (Dependent)
        SettingsDir
        IconsDir
        SaveDir
        
        SaveFile
    end
    
    properties (SetAccess = protected, GetAccess = protected)
        SettingsDir_ = '';
        IconsDir_ = '';
        SaveDir_ = '';
    end
    
    
    
    
        
    methods(Access = public)
        function self = DataBrowser(varargin)
            % Check dependencies first. Might be an option to put it in the
            % single classes though.
            self.checkDependencies(2);
            
            self.Model = databrowser.Model();
            self.View = databrowser.GUI(self);
            
            self.View.initiate();
            
            if nargin == 1
                self.SettingsDir = varargin{1};
            end
            
            self.loadSettings();
            showSettings = isempty(self.DataDirectories);
            while showSettings
                settings = self.View.getSelectedDirectories(...
                    self.DataDirectories, ...
                    self.IconsDir, ...
                    self.SaveDir ...
                );
                
                if isempty(settings.DataDirs)
                    sel = questdlg('Show settings again?', 'At least one data directory is required', 'Show settings again', 'Quit DataBrowser', 'Show settings again');
                    switch sel
                        case 'Quit DataBrowser'
                            delete(self);
                    end
                else 
                    showSettings = false;
                    self.DataDirectories = settings.DataDirs;
                    self.IconsDir = settings.IconsDir;
                    self.SaveDir = settings.SaveDir;
                    
                end
            end
            % for debugging...
            % self.View.show();
            
            % Todo at startup:
            % - Load data
            self.Model.initiate(self.SaveFile, self.DataDirectories, self.IconsDir);
            % - (Re)scan directory
            % - Check for deleted files
            % - Check for changed files
            % - Check for new files
            % - generate previews of new/changed files.
            
            
            %self.startGUI('DB');
            %self.generate_dir_tree();
        end
%        function delete ( self )
%            
%        end 
        
        function close(self)
            self.saveData();
            self.saveSettings();
            
            delete(self.View);
            delete(self);
        end
    end % con/destructors
        
    methods (Access = public)
        function getSettings(self, varargin)
            settings = self.View.getSelectedDirectories(...
                    self.DataDirectories, ...
                    self.IconsDir, ...
                    self.SaveDir ...
            );
            fprintf('Datadirs:\n');
            settings.DataDirs
            self.DataDirectories = {settings.DataDirs};
            self.IconsDir = settings.IconsDir;
            self.SaveDir = settings.SaveDir;
            msgbox('Changes will take effect on next start.','Settings changed');
        end
    end
    
    methods % getter/setter
        function d = get.SaveDir ( self )
            if isempty(self.SaveDir_)
                d = [userpath() filesep() self.DEFAULTSAVEDIR];
            else
                d = self.SaveDir_;
            end
        
        end
        function set.SaveDir( self, d )
            self.SaveDir_ = d;
        end
        
        function d = get.SettingsDir ( self )
            if isempty(self.SettingsDir_)
                d = [userpath() filesep() self.DEFAULTSETTINGSDIR];
            else
                d = self.SettingsDir_;
            end
        
        end
        function set.SettingsDir( self, d )
            self.SettingsDir_ = d;
        end
        
        function d = get.IconsDir ( self )
            if isempty(self.IconsDir_)
                d = [userpath() filesep() self.DEFAULTICONSDIR];
            else
                d = self.IconsDir_;
            end
        end
        function set.IconsDir( self, d)
            self.IconsDir_ = d;
        end
        
        function fn = get.SaveFile( self )
            fn = [self.SaveDir filesep() self.SAVEFILENAME];
        end
        function set.SaveFile( self, ~ )
            phutils.warn_readonly_property('DataBrowser','SaveFile', class(self));
        end
           
    end % getter/setter
    
    methods (Access = protected)
        loadSettings(self) % load Settings
        loadData(self) % load Data
  
        
        
        saveDate(self) % saves the data
        saveSettings(self) % saves the Settings
        
        st = settings2struct(self) % gets the settings as struct
        
        
    end
    methods(Static)
        varargout = version % Print or get version of the DataBrowser
    end % static methods
end