classdef (Abstract) PreviewedData < matlab.mixin.SetGet
    properties (Abstract, Constant)
        FILETYPES
    end
    
    properties (SetObservable)
        Ready = false;
    end
    properties
        File
        FileTime
        IconFiles = {};
        IconTimes
        Error
        Manual = false
        Directory = '.'
    end
    
    methods
        function self = PreviewedData(varargin)
            phutils.set( self, varargin{:});
            
            if ~self.Manual
                if isempty(self.IconFiles)
                    self.generatePreviews();
                end
            end
        end
        
        function struc = toStruct( self )
            
            struc = struct(...
                'Classname', class(self),...
                'File', self.File, ...
                'FileTime', self.FileTime, ...
                'IconFiles', self.IconFiles, ...
                'IconTimes', self.IconTimes ...
            );
        end
    end
    
    methods (Access = public, Abstract)
        generatePreviews( self ); 
        val = open( self );
    end
    
    methods (Access = protected)
        function fn = getUniqueFilename(~)
            fn = num2str(now()*1e10);
        end
        function checkIconDir(self)
            if ~exist(self.Directory,'dir')
                mkdir(self.Directory);
            end
        end
    end
    
end