classdef Model < matlab.mixin.SetGet
    properties (SetObservable, Access = public)
        Data = {};
        IsReady
        CurrentMsg
        TotalFraction
        SubFraction
        
        
    end
    
    properties (SetAccess = protected, GetAccess = public)
        icondir = [];
        directories = {};
        Cache = {};
        CacheFilename;
        DataReaders
        
        Files = {}
    end
    
    properties (Access = protected )
        StartupSteps 
    end % protected props
    
    methods % Con-/Destructor
        function self = Model()

            %self.lookupDatareaders();
            
            self.StartupSteps = databrowser.DBInitializingSteps(...
                @(msg)(set(self, 'CurrentMsg', msg)), ...
                @(frac)(set(self, 'TotalFraction', frac)),...
                @(frac)(set(self, 'Subfraction', frac)) ...
            ); % Steps are set in self.initialize
            
        end
    end % Con-/Destructor
    
    methods
        
        initiate( self, fn, directories, icondir ) % Initiates the data, fn: filename to load
        loadCache(self)
        initializeCache(self, cnt);
        scanDirectories(self, cnt);
        generatepreview(self, cnt);
        
        saveDataTo(self, fn);
    end % public methods
    
    methods (Access = protected)
        lookupDatareaders(self);
    end
end