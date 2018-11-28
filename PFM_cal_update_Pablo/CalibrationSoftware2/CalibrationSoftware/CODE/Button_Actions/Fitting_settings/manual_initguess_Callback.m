
% --- Fitting settings: manual initial guess
function manual_initguess_Callback(hObject, eventdata, handles)
%Alternating between 'manual' and 'automatic' options. 
set(handles.automatic_initguess,'value',0)
set(handles.manual_initguess,'value',1)
