classdef SICMPreviewedData < databrowser.PreviewedData
    properties ( Constant )
        FILETYPES = {'sicm','sic', 'ras'};
    end
    
    methods
        function val = open( self )
            val = SICM.SICMScan.FromFile(self.File);
        end
        function generatePreviews( self )
            self.checkIconDir();
            f = figure(...
                'Visible','off',...
                'Position',[1,1,128,128]...
            );
            ax = axes(f,...
                'Units','pixels',...
                'Position',[1,1,128,128],...
                'Visible','off',...
                'DataAspectratio',[1 1 1],...
                'DataAspectRatioMode','manual'...
            );
            try
                scan = SICM.SICMScan.FromFile(self.File);
                ok = true;
            catch e
                ok = false;
            end
            if ok
                imagesc(ax, scan.zdata_grid);
                colormap(ax, parula);
                fn = [self.Directory filesep self.getUniqueFilename() '.png'];
                export_fig(fn, '-nocrop', '-png', f);
                self.IconTimes = [now()];
                delete(f);
                self.IconFiles =  {fn};
                self.Error = false;
            else
                self.Error = true;
            end
            self.Ready = true;
        end
    end
end