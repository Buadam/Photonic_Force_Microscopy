 
%moving slider of k
function kslider_Callback(hObject, eventdata, handles)
global rapid
rapid=1;
set(handles.k,'string',num2str(get(handles.kslider,'value')));
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)
