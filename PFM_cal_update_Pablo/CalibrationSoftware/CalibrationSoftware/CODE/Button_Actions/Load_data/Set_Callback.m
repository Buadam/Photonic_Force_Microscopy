% Cropping experimental data.
function Set_Callback(hObject, eventdata, handles)

global psdx msdx vafx
%Cropping PSD
if ~isempty(psdx)
    %crop low frequency
    ind=find(psdx(:,1)>str2double(get(handles.lowfreq,'string')),1,'first');
    psdx=psdx(ind:end,:);
    %crop high frequency
    ind=find(psdx(:,1)>str2double(get(handles.highfreq,'string')),1,'first');
    if ~isempty(ind)
        psdx=psdx(1:ind-1,:);
    end
end

%Cropping MSD
if ~isempty(msdx)
    %crop long times
ind=find(msdx(:,1)>str2double(get(handles.longtime,'string')),1,'first');
if ind>0
    msdx=msdx(1:ind,:);
end
%crop short times
ind=find(msdx(:,1)>str2double(get(handles.shorttime,'string')),1,'first');
    if ind>0
        msdx=msdx(ind:end,:);
    end
end


%Cropping VAF
if ~isempty(vafx)
    %crop long times
ind=find(vafx(:,1)>str2double(get(handles.longtime,'string')),1,'first');
if ind>0
vafx=vafx(1:ind,:);
end
%crop short times
ind=find(vafx(:,1)>str2double(get(handles.shorttime,'string')),1,'first');
if ind>0
vafx=vafx(ind:end,:);
end
end

%Plot cropped graphs
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)
