
% --- Fitting settings: Model select
function double_Callback(hObject, eventdata, handles)
%Alternating between 'Spherical' and 'Non-spherical' options
set(handles.single,'Value',0);
set(handles.double,'Value',1);