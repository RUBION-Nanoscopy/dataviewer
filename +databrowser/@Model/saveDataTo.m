function saveDataTo( self, filename )
    cache = cell(numel(self.Data),1);
    for i = 1:numel(self.Data)
        cache{i} = self.Data{i}.toStruct();
    end
    save(filename, 'cache');