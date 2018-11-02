function shift(self, by)
%SHIFT shift the current Index
    idx = self.StartIndex;
    
    idx = idx + by;
    
    if idx > numel(self.Model.Data)
        self.StartIndex = idx - numel(self.Model.Data);
    elseif idx <= 0
        self.StartIndex = numel(self.Model.Data) - idx;
    else
        self.StartIndex = idx;
    end