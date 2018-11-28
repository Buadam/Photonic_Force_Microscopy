% --- Plot with actual parameters. Action for button press
function Plot_with_actual_parameters_Callback(hObject, eventdata, handles)
global rapid
rapid=0;
set(handles.statusbar,'string','Plotting Actual Fit')
%Calculating functions and plotting in GUI
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)

