% --- Executes on button press in Clearall.
function Clearall_Callback(hObject, eventdata, handles)
%Clears graphs and experimental data from memory
clear global;
cla(handles.psdplot)
cla(handles.msdaxes)
cla(handles.vafplot)