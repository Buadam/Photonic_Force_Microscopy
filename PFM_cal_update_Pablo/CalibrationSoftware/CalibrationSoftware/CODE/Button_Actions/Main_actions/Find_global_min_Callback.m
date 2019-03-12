
% --- Executes on button press Find Global Minimum.
function Find_global_min_Callback(hObject, eventdata, handles)
%Start functions to fit by Maximum Likelihood

set(handles.statusbar,'String','Performing Simulated Annealing')
drawnow;

        %%
        %Single plateau fitting with CI
        
        %reading original parameters set in the 'Manual fitting' menu. 
        disp('Original fitting parameters')
            as0=1e-6*str2double(get(handles.as,'string'))
            k0=1e-6*str2double(get(handles.k,'string'))
            b0=str2double(get(handles.b,'string'))
            PSDrot0=str2double(get(handles.PSDmax,'string'))
            MSDrot0=str2double(get(handles.MSDmax,'string'))
            %Obtain error from maximum likelihood fitting started from the
            %original set of parameters
            [~,~,~,~,~,Confidence_lin,R,~]=MaxLikelihood_Callback(hObject, eventdata, handles,as0,k0,b0,PSDrot0,MSDrot0);
            ERR0=norm(R);
            disp(['Original residual:' num2str(ERR0)])
            
            %Creating 2D grid of radius and spring constant parameters to
            %find the one with the best convergence.
            av=as0-0.1*as0:0.05*as0:as0+0.1*as0;
            kv=k0-0.1*k0:0.05*k0:k0+0.1*k0;
            
            
            as=as0; k=k0; b=b0; PSDrot=PSDrot0; MSDrot=MSDrot0;
            for i=1:size(av,2)
                for j=1:size(kv,2)
                   set(handles.statusbar,'String',['Global minimum search: ' num2str((i-1)*size(kv,2)+j) ' out of ' num2str(size(av,2)*size(kv,2))])
                   drawnow;
                   %Calling MaxLikelihood method to fit the selected
                   %functions from initial parameter values selected from
                   %the 2D parameter grid. 
                   [as1,k1,b1,PSDrot1,MSDrot1,Confidence_lin1,R1,~]=MaxLikelihood_Callback(hObject, eventdata, handles,av(i),kv(j),b0,PSDrot0,MSDrot0);
                        if norm(R1)<norm(R) %If the actual fit is better than the best fit so far
                            as=as1;
                            k=k1;
                            b=b1;
                            PSDrot=PSDrot1;
                            MSDrot=MSDrot1;
                            Confidence_lin=Confidence_lin1;
                            R=R1; %Actual residual becomes the best (smallest) one
                        end
                end
            end
            
 %Displaying results           
            set(handles.asfit,'String',num2str(as*1e6))
            set(handles.kfit,'String',num2str(k*1e6))
            set(handles.bfit,'String',num2str(b))
            set(handles.PSDmaxfit,'String',num2str(1e-3*PSDrot))
            set(handles.MSDmaxfit,'String',num2str(0.1*MSDrot))
            set(handles.amin,'String',num2str(Confidence_lin(1,1)))
            set(handles.amax,'String',num2str(Confidence_lin(1,2)))
            set(handles.kmin,'String',num2str(Confidence_lin(2,1)))
            set(handles.kmax,'String',num2str(Confidence_lin(2,2)))
            set(handles.bmin,'String',num2str(Confidence_lin(3,1)))
            set(handles.bmax,'String',num2str(Confidence_lin(3,2)))
            set(handles.PSDmaxmin,'String',num2str(Confidence_lin(4,1)))
            set(handles.PSDmaxmax,'String',num2str(Confidence_lin(4,2)))
            set(handles.MSDmaxmin,'String',num2str(Confidence_lin(5,1)))
            set(handles.MSDmaxmax,'String',num2str(Confidence_lin(5,2)))
            set(handles.as,'String',num2str(as*1e6))
            set(handles.aslider,'Value',as*1e6)
            set(handles.k,'String',num2str(k*1e6))
            set(handles.kslider,'Value',k*1e6)
            set(handles.b,'String',num2str(b))
            set(handles.bslider,'Value',b)
            set(handles.PSDmax,'String',num2str(1e-3*PSDrot))
            set(handles.PSDslider,'Value',1e-3*PSDrot)
            set(handles.MSDmax,'String',num2str(0.1*MSDrot))
            set(handles.MSDslider,'Value',0.1*MSDrot)
      
            %Selecting the result with the lowest residual
            ERRmin=norm(R);
            disp(['Final residual:' num2str(ERRmin)])
            
            if ERR0>ERRmin
                set(handles.statusbar,'string','Lower minimum found')
            else
                set(handles.statusbar,'string','No lower than original minimum found') 
            end
       
