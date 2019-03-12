%Loading MSD data by typing in path

function msdpath_Callback(hObject, eventdata, handles)
global msdx
FilePath=get(handles.msdpath,'string');
if ~exist(FilePath, 'file')
    msgbox('File not found', 'Warning!','Warn');
else
msdx=dlmread(FilePath,'\t',1,0);
if size(msdx,2)==2 %if there are only two columns in the text file
        msgbox('File does not contain error values, weighted fitting is not possible', 'Warning!','Warn');
        msdx=[msdx zeros(size(msdx,1),1)];
end
set(handles.statusbar,'string','MSD data loaded')
end