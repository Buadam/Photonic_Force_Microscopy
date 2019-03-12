%Loading MSD data
function loadMSD_Callback(hObject, eventdata, handles)
global msdx
[FileName, PathName]=uigetfile('*.txt','Open the MSD data');

if isequal(FileName,0)
    msgbox('File not found', 'Warning!','Warn');
else
set(handles.msdpath,'string',fullfile(PathName, FileName));
msdx=dlmread(fullfile(PathName, FileName),'\t',1,0);
if size(msdx,2)==2 %if there are only two columns in the text file
        msgbox('File does not contain error values, weighted fitting is not possible', 'Warning!','Warn');
        msdx=[msdx zeros(size(msdx,1),1)];
end
set(handles.statusbar,'string','MSD data loaded')
end