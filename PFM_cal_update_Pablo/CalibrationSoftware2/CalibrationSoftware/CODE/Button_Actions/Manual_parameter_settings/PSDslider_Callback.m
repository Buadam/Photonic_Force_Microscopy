
%moving PSDslider
function PSDslider_Callback(hObject, eventdata, handles)
global rapid
rapid=1;
set(handles.PSDmax,'string',num2str(get(handles.PSDslider,'value')));
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)