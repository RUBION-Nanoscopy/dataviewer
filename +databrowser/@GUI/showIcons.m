function showIcons( self )
%SHOWICONS shows ths icons
 
    map = [1 3 5 7 2 4 6 8];
    for i = 0 : numel(self.AxesCollection)-1
        dataIdx = mod(self.StartIndex+i, numel(self.Model.Data));
        if dataIdx == 0; dataIdx = numel(self.Model.Data); end
        ax = self.AxesCollection{map(i+1)};
        ax.Content = self.Model.Data{dataIdx};
        
    end