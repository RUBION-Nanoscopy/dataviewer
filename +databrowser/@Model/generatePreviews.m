function generatePreviews(self, cnt)

    file = self.Files{cnt};
    self.Data{end+1} = eval([file.dr '(''Filename'',' file.folder filesep file.name ',''FileTime'',' file.datenum ');']);