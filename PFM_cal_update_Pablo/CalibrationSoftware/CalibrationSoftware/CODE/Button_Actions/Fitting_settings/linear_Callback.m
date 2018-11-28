
% --- Fitting settings: No transformation before fitting.
function linear_Callback(hObject, eventdata, handles)
%Alternating between 'linear' and 'logarithmic' options. Linear option
%requires data to be weighted.
set(handles.logarithmic,'value',0)
set(handles.linear,'value',1)
set(handles.weighting,'Value',1)