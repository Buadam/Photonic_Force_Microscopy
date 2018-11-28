% --- Fitting settings: automatic initial guess
function automatic_initguess_Callback(hObject, eventdata, handles)
%Alternating between 'automatic' and 'manual' options
set(handles.automatic_initguess,'value',1)
set(handles.manual_initguess,'value',0)