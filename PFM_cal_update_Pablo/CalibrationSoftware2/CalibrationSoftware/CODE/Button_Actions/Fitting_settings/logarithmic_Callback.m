
% --- Fitting settings: Logarithmic transformation to [0 1] interval before fitting.
function logarithmic_Callback(hObject, eventdata, handles)
%Alternating between 'linear' and 'logarithmic' options. Logarithmic option
%requires no weighting
set(handles.linear,'value',0)
set(handles.logarithmic,'value',1)
set(handles.weighting,'Value',0)