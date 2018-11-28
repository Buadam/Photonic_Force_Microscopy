%Transforming experimental data (linear or logarithmic) and performing the
%weighting. The function also concatenates the experimental PSD, MSD and
%VAF data separated in three arrays: xdata,ydata and errdata. The function
%returns the sizes of the three functions (sizePSD, sizeMSD and sizeVAF)
%for the separation of the three observables for separate plotting

function [xdata,ydata,errdata,sizePSD,sizeMSD,sizeVAF]=preprocess(select,psdx,msdx,vafx,weighting,method)
%Initialization
xdata=[];
ydata=[];
errdata=[];

sizePSD=0;
sizeMSD=0;
sizeVAF=0;

if weighting==1
    %Eliminate datapoints with zero errorbar to avoid division by 0
    if ~isempty(psdx)
        indpsd=find(psdx(:,3)); %Finding non-zero elements in the error
    end
    if ~isempty(msdx)
        indmsd=find(msdx(:,3)); %Finding non-zero elements in the error
    end
    if ~isempty(vafx)
        indvaf=find(vafx(:,3)); %Finding non-zero elements in the error
    end
else
    
    indpsd=(1:1:size(psdx,1))'; 
    indmsd=(1:1:size(msdx,1))';
    indvaf=(1:1:size(vafx,1))';
end

%Concatenating experimental data. The output arrays will contain only those
%data which are selected for fitting under 'Functions to fit' menu.
if select(1)==1 %PSD Least-square fitting selected
    xdata=[psdx(indpsd,1)];

    if method==0 %No transformation, weighting by calculated error values 
        
        disp('No transformation of PSD, MSD, VAF')
        ydata=psdx(indpsd,2);
        errdata=psdx(indpsd,3);
        
    elseif method==1 %logarithmic PSD transformation to [0,1] interval
        disp('Logarithmic transformation of data and model function to the [0,1] interval')
        A=max(psdx(indpsd,2));
        B=min(log(psdx(indpsd,2)/A));
        ydata=[log(psdx(indpsd,2)/A)/B];   
        errdata=[psdx(indpsd,3)./psdx(indpsd,2)/B];
    end
    sizePSD=size(indpsd,1);
end

if select(2)==1 %MSD Least-square fitting selected - appending to the PSD (if selected)
    xdata=[xdata;msdx(indmsd,1)]; 
    if method==0 %No transformation
        ydata=[ydata;msdx(indmsd,2)];
        errdata=[errdata;msdx(indmsd,3)];
    elseif method==1 %logarithmic MSD transformation to [0,1] interval
        A=max(msdx(indmsd,2));
        B=min(log(msdx(indmsd,2)/A));
        ydata=[ydata; log(msdx(indmsd,2)/A)/B];
        errdata=[errdata; msdx(indmsd,3)./msdx(indmsd,2)/B];
    end
    sizeMSD=size(indmsd,1);
end

if select(3)==1 %VAF Least-square fitting selected - appending to the PSD and MSD (if selected)
    xdata=[xdata;vafx(indvaf,1)];
    if method==0 %No transformation
        ydata=[ydata;vafx(indvaf,2)];
        errdata=[errdata;vafx(indvaf,3)];
    elseif method==1 %logarithmic VAF transformation to [0,1] interval
        A=max(vafx(indvaf,2));
        B=min(log(abs(vafx(indvaf,2)/A)));
        ydata=[ydata;log(abs(vafx(indvaf,2)/A))/B];
        errdata=[errdata;sign(vafx(indvaf,2)).*vafx(indvaf,3)./vafx(indvaf,2)/B];
        
    end
    sizeVAF=size(indvaf,1);
end
