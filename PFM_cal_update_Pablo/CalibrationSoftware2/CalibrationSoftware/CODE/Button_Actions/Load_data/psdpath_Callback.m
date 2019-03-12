%Loading PSD data by typing in path

function psdpath_Callback(hObject, eventdata, handles)
global psdx
FilePath=get(handles.psdpath,'string');
if ~exist(FilePath, 'file')
    msgbox('File not found', 'Warning!','Warn');
else
psdx=dlmread(FilePath,'\t',1,0);
 if size(psdx,2)==2 %if there are only two columns in the text file
        msgbox('File does not contain error values, weighted fitting is not possible', 'Warning!','Warn');
        psdx=[psdx zeros(size(psdx,1),1)];
 end
set(handles.statusbar,'string','PSD data loaded')
end
