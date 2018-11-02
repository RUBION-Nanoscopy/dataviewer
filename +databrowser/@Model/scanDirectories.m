function scanDirectories(self, cnt)
%SCANDIRECTORIES  Scans the observed directories for known data files
    
    dr = self.DataReaders{cnt};
    if ~iscell(self.directories) 
        self.directories = {self.directories};
    end
    
    for j = 1:numel(self.directories)
        directory = [self.directories{j} filesep '**' filesep '*.' dr.ext];
        files  = dir(directory);
        for i = 1:numel(files)
            self.Files{end +1} = struct('dr',dr.cls.Name, 'f', files(i));
        end
    end
    