classdef MSRPreviewedData < databrowser.PreviewedData
    properties ( Constant )
        FILETYPES = {'msr'};
    end
    
    methods
        function val = open ( self )
            val = bfopen(self.File);
        end
        function generatePreviews( self )
            self.checkIconDir();
            try
                bf = bfopen(self.File);
                okay = true;
            catch e
                okay = false;
            end
            
            if okay
                f = figure(...
                    'Visible','off',...
                    'Position', [0 0 128 128]...
                );
                ax = axes(f,...
                    'Units','pixels',...
                    'Position',[1,1,128,128],...
                    'Visible','off',...
                    'DataAspectratio',[1 1 1],...
                    'DataAspectRatioMode','manual'...
                );
                for i = 1:size(bf, 1)
                    data = bf{i,1}{1};
                    if size(data,1) > 1
                        if all(data(:,1) > data(:,2))
                            data = data(:,2:end);
                        end
                        imagesc(ax, data);
                        ax.Visible='off';
                        colormap(ax, hot);
                        fn = [self.Directory filesep self.getUniqueFilename() '.png'];
                        export_fig(fn, '-nocrop', '-png', f);
                        self.IconFiles{i} = fn;
                        self.IconTimes(i) = now();
                    end
                end
                delete(f);
               
            end
            
        end
    end
end