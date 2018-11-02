function loadCache(self)
%LOADCACHE  loads the cached data
    loadedData = [];
    try 
        loadedData = load(self.CacheFilename, 'cache');
    catch
        warning('DataBrowser:FileNotreadable', 'No readable cache file found');
    end
    if ~isempty(loadedData)
        self.Cache = loadedData.cache;
    end
