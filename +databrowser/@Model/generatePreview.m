function generatePreview(self, cnt)

    file = self.Files{cnt};
    filename = [ file.f.folder filesep file.f.name ];
    execute = sprintf(...
        '%s(''File'',''%s'',''FileTime'',%g, ''Directory'',''%s'')',...
        file.dr, filename, file.f.datenum, self.icondir ...
    );
    self.Data{end+1} = eval(execute);