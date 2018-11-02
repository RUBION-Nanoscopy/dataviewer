classdef GUI < handle
    properties ( Access = protected )
        Controller;
        Model; 
        Figure % The figure
        Splash % The splash figure;
        Settings % The settings figure
        SettingsFields = struct() % Fields in the settings view
        SplashAxes = struct(); % The axes on the splash screen
        Menu = struct() % The main menu and its components
        SplashProgressBars = struct() % Components of the progress bars...
        SplashProgressText % The progress text...
        Layout % The layout
        AxesCollection = [] % The collection of the axes

        LoadListeners = struct();
        
        
    end
    
    properties (SetObservable)
        StartIndex = 1;
    end
    
    methods 
        
        function self = GUI( controller )
            self.Controller = controller;
            self.Model = self.Controller.Model;
        end
        
        function initiate( self )
            self.composeGUI(); 
        end
        function show( self )
            
            if self.Model.IsReady
                self.Splash.Visible = 'off';
                self.Figure.Visible = 'on';
                self.showIcons();
                self.addlistener('StartIndex', 'PostSet', @(src,evt)(self.showIcons()));
                self.Figure.KeyPressFcn = @self.onKeyPress;
            else
                self.Splash.Visible = 'on';
                
            end
            drawnow();
        end
        
        function delete( self )
            if ishandle(self.Splash)
                delete(self.Splash);
            end
            if ishandle( self.Settings )
                self.Settings.CloseRequestFcn = '';
                delete(self.Settings);
            end
            if ishandle( self.Figure )
                delete(self.Figure);
            end
        end
    end
    
    methods (Access = protected)
        function composeGUI( self )
            self.Figure = figure(...
                'MenuBar','none',...
                'ToolBar','none',...
                'WindowState','maximized',...
                'NumberTitle', 'off',...
                'Visible','off',...
                'CloseRequestFcn', @(~,~)self.Controller.close, ...
                'Name', self.Controller.TITLE );
            self.Splash = figure(...
                'MenuBar', 'none', ...
                'ToolBar', 'none',...
                'NumberTitle','off',...
                'Visible','off',...
                'Name', sprintf('Starting %s', self.Controller.TITLE) ...
            );
            self.Settings = figure(...
                'MenuBar', 'none', ...
                'ToolBar', 'none',...
                'NumberTitle','off',...
                'Visible','off',...
                'Name', 'Settings' ...
            );
            self.addGuiComponents();
            self.addListeners();
        end
        
        function onKeyPress( self, ~, evt )
            switch evt.Key
                case 'rightarrow'
                    self.shift(1);
                case 'leftarrow'
                    self.shift(-1);
                case 'pagedown'
                    self.shift(...
                        numel(self.Layout.Children(2).Widths) * ...
                        numel(self.Layout.Children(2).Heights));
                case 'pageup'
                    self.shift(-1* ...
                        numel(self.Layout.Children(2).Widths) * ...
                        numel(self.Layout.Children(2).Heights));
            end        
        end
    end
    
    methods ( Access = private )
        function addGuiComponents( self )
            self.addMenu();
            self.addLayout();
            self.composeSplash();
            self.composeSettings();
        end
    
        
        addMenu( self ); % Generates the Menu bar
        addLayout( self ); % Generates the layout
        
        composeSplash(self); 
        addListeners( self ); 
        showIcons(self);
        
        shift(self, by);
    end
    methods
        
        dirs = getSelectedDirectories( self,  dataDirs, settingsDir, iconsDir, saveDir )
    end
        
end