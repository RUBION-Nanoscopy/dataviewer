function lookupDatareaders( self )
%LOOKUPDATAREADERS  Loads the list of known "datareaders" 
%
%   datareaders should inherit from databrowser.PreviewedData and be stored
%   in +databrwoser/+previeweddata/
    
    

    packagelist = meta.package.getAllPackages();
    db = packagelist{cellfun(@(x)strcmp(x.Name,'databrowser'), packagelist)};
    drpack = db.PackageList(strcmp(db.PackageList(:).Name, 'databrowser.previeweddata'));
    classes = drpack.ClassList;
    
    for i = 1:numel(classes)
        % using eval here is ugly
        fts = eval([classes(i).Name '.FILETYPES']);
        for j = 1:numel(fts)
            self.DataReaders{end+1} = struct('ext', fts{j}, 'cls', classes(i));
        end
    end
