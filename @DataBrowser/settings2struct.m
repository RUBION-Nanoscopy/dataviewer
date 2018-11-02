function st = settings2struct( self )
%SETTINGS2STRUCT  returns the current settings as struct

    st = struct();
    st.IconsDir = self.IconsDir_;
    st.SaveDir = self.SaveDir_;
    st.DataDirectories = self.DataDirectories;
 
    