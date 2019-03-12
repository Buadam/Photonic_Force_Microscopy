%Loading VAF data by typing in path

function vafpath_Callback(hObject, eventdata, handles)
global vafx
FilePath=get(handles.vafpath,'string');
if ~exist(FilePath, 'file')
    msgbox('File not found', 'Warning!','Warn');
else
vafx=dlmread(FilePath,'\t',1,0);
if size(vafx,2)==2 %if there are only two columns in the text file
        msgbox('File does not contain error values, weighted fitting is not possible', 'Warning!','Warn');
        vafx=[vafx zeros(size(vafx,1),1)];
end
set(handles.statusbar,'string','VAF data loaded')
end
