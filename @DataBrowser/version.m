function varargout = version
%VERSION  DataBrowser version
% 
% DataBrowser.version
%   prints the current version
%
% version = DataBrwoser.version
%   returns the version string
%
    v = sprintf('\n%s\nVersion: %g.%g (%s)\n\n', ...
                    DataBrowser.title, ...
                    DataBrowser.major_version, ...
                    DataBrowser.minor_version, ...
                    DataBrowser.version_comment ...
                );  
    if nargout > 0
        varargout{1}=v;
    else
        fprintf('%s',v);
    end