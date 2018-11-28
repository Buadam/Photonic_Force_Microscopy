%Loading PSD data
%%
function loadpsd_Callback(hObject, eventdata, handles)
global psdx
[FileName, PathName]=uigetfile('*.txt','Open the PSD data');

if isequal(FileName,0)
    msgbox('File not found', 'Warning!','Warn');
else
set(handles.psdpath,'string',fullfile(PathName, FileName));

psdx=dlmread(fullfile(PathName, FileName),'\t',1,0);

    if size(psdx,2)==2 %if there are only two columns in the text file
        msgbox('File does not contain error values, weighted fitting is not possible', 'Warning!','Warn');
        psdx=[psdx zeros(size(psdx,1),1)];
    end
set(handles.statusbar,'string','PSD data loaded')
end
