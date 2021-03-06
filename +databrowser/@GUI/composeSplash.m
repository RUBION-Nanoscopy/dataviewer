function composeSplash( self )
%COMPOSESPLASH  Composes the start-up splash screen

    % save old screen units...
    oldunits = get(0,'units');
    % set to pixels
    set(0,'units','pixels');

    screensize = get(0,'screensize');
    
    % Splash screen size should be 1/3 of width/height
    w = round(screensize(3)/3);
    h = 168;%round(screensize(4)/3);
    self.Splash.Position = [...
            (screensize(3)-w)/2, ...
            (screensize(4)-h)/2, ...
            w h];
    self.SplashAxes.Image = axes(...
        'Parent', self.Splash,...
        'Units', 'normalized',...
        'Position',[0 0 1 1], ...
        'Visible', 'off' ...
    );

    % generate splash image :)

    im = rand(h,w);
    
    imagesc(self.SplashAxes.Image, im);
    colormap(self.SplashAxes.Image, hot);
    % self.SplashAxes.Image.Visible = 'off';

    self.SplashProgressBars.Major = ...
        phutils.gui.ProgressBar(...
            self.SplashAxes.Image,...
            'XPadding', 20, ...
            'YPadding', 24, ...
            'Height', 48, ...
            'AutoLabel', true, ...
            'AutoLabelFormat', 'Starting %3.1i%%' ...
        );
    self.SplashProgressBars.Minor = ...
        phutils.gui.ProgressBar(...
            self.SplashAxes.Image,...
            'XPadding', 20, ...
            'YPadding', 96, ...
            'Height', 48, ...
            'AutoLabel', false ...
        );
    
    % restore old screen units
    set(0,'units',oldunits);