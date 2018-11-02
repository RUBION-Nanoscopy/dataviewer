classdef PreviewField < uix.VBox
    
    properties
        Edit
        Ax
        Btns 
        IconCounter
    end
    properties(Access = protected, SetObservable)
        IconIdx
        Content_
    end
    
    properties(Dependent)
        Content
    end
    
    methods
        function self = PreviewField(varargin)
            
            self.Ax = axes('Parent',uicontainer('Parent',self), ...
            ...%    'Visible', 'off', ...
                'DataAspectRatio', [1 1 1], ...
                'DataAspectRatioMode','manual' ...
            );
            self.IconCounter = uix.Text('Parent', self);
            self.Btns = uix.HBox(...
                'Parent', self );
            uicontrol(self.Btns, ...
                'String','<', ...
                'Callback', @(~,~)self.shift(-1) ...
            );
            self.Edit = uicontrol(self.Btns, ...
                'Style', 'Edit', ...
                'Enable', 'inactive' ...
            );
            uicontrol(self.Btns, ...
                'String','>', ...
                'Callback', @(~,~)self.shift(1) ...
            );
            uicontrol(self, ...
                'String','Open', ...
                'Callback', @(~,~)self.openData() ...
            );
            self.Btns.Widths=[32 -1 32];
            try
                uix.set( self, varargin{:} )
            catch e
                delete( self )
                e.throwAsCaller()
            end
            self.Heights = [-1 32 32 32];
            
            self.addlistener('IconIdx', 'PostSet', ...
                @(src, evt)self.update() ...
            );
        end
    end
    
    methods 
        function set.Content( self, content)
            self.Content_ = content;
            self.IconIdx = 1;
            
            
        end
        
        function c = get.Content( self )
            c = self.Content_;
        end
    end % Getter/Setter
    
    methods (Access = protected)
        function update(self)
            try
                im = imread(self.Content_.IconFiles{self.IconIdx});
                error = false;
                img = image(self.Ax, im);
            catch
                im = checkerboard(8,8)>.5;
                error = true;
                img = imagesc(self.Ax, im);
                colormap(self.Ax, gray);
                
            end
            
            
            img.Parent.DataAspectRatio = [1 1 1];
            self.Ax.Visible='off';
            self.IconCounter.String  = sprintf('%g/%g', self.IconIdx, numel(self.Content_.IconFiles));
            self.Edit.String = self.Content_.File;
        end
        
    
    
        function shift( self, by)
            idx = self.IconIdx + by;
            if idx > 0 && idx <= numel(self.Content_.IconFiles)
                self.IconIdx = idx;
            elseif idx > numel(self.Content_.IconFiles)
                self.IconIdx = 1;
            else
                self.IconIdx = numel(self.Content_.IconFiles);
            end
        end 
        
        function openData(self)
            varname = 'data';
            c=0;
            while evalin('base', sprintf('exist(''%s'', ''var'')', varname))
                varname = sprintf('data%g', c);
                c=c+1;
            end
            name = inputdlg(...
                {'Provide a variable name'}, ...
                'Opening data in workspace', ...
                1, ...
                {varname} ...
            );
            if ~isempty(name)
                assignin('base', name{1}, self.Content_.open());
                fprintf('The variable <%s> has been created.\n', name{1});
            end
        end
    end
end