
%moving MSDslider
function MSDslider_Callback(hObject, eventdata, handles)
global rapid
rapid=1;
set(handles.MSDmax,'string',num2str(get(handles.MSDslider,'value')));
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)