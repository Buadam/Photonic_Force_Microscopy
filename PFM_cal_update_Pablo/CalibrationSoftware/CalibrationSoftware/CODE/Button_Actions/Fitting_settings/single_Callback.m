
% --- Fitting settings: Model select
function single_Callback(hObject, eventdata, handles)
%Alternating between 'Spherical' and 'Non-spherical' options. 
set(handles.double,'Value',0);
set(handles.single,'Value',1);