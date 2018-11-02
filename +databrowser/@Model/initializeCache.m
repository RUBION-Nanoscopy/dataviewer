function initializeCache(self, cnt)
%INITIALIZECACHE  initializes the cached data
    %self.Data{end +1} = 
    %fprintf('Counter is %g\n', cnt);
    %disp('init cache start');
    %conv2(rand(512),rand(512));
    %disp('init cache end');
    
    
    
    if isempty(self.Cache{cnt})
        return
    end
    entry = self.Cache{cnt};
    fn = entry.File;
    
    idx = find(...
        cellfun(...
            @(x)strcmp(fn,sprintf('%s%s%s', x.f.folder, filesep, x.f.name)),...
            self.Files ...
        ), ...
        1 ...
    );
    
    if entry(1).FileTime >= self.Files{idx}.f.datenum
        self.Files(idx) = [];
        execute = sprintf(...
            '%s(''File'',''%s'',''Manual'',true)', entry(1).Classname, fn ...
        );
        self.Data{end+1} = eval(execute);
        self.Data{end}.IconFiles = {entry.IconFiles};
        self.Data{end}.FileTime = entry.FileTime;
    end
    
    fprintf('Size of files is %i\n', numel(self.Files));