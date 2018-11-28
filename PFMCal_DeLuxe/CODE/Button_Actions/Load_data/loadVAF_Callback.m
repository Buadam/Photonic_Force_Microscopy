%Loading VAF data

function loadVAF_Callback(hObject, eventdata, handles)
global vafx
[FileName, PathName]=uigetfile('*.txt','Open the VAF data');

if isequal(FileName,0)
    msgbox('File not found', 'Warning!','Warn');
else
set(handles.vafpath,'string',fullfile(PathName, FileName));
vafx=dlmread(fullfile(PathName, FileName),'\t',1,0);
if size(vafx,2)==2 %if there are only two columns in the text file
        msgbox('File does not contain error values, weighted fitting is not possible', 'Warning!','Warn');
        vafx=[vafx zeros(size(vafx,1),1)];
end
set(handles.statusbar,'string','VAF data loaded')
end
