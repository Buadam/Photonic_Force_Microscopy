%clear all;
%close all;
%profile on
%tic
%fid = fopen('J:\suli\bme\PhD\Lausanne_2014jan_feb\Hydrodynamic_Calibration_Software\xyz_processer\x.txt');
%x=(fread(fid,[1,inf],'bit16'))';
%fclose(fid);
%fid = fopen('J:\suli\bme\PhD\Lausanne_2014jan_feb\Hydrodynamic_Calibration_Software\xyz_processer\y.txt');
%y=(fread(fid,[1,inf],'bit16'))';
%fclose(fid);
%fid = fopen('J:\suli\bme\PhD\Lausanne_2014jan_feb\Hydrodynamic_Calibration_Software\xyz_processer\z.txt');
%z=(fread(fid,[1,inf],'bit16'))';
%fclose(fid);

A=[x(1:1e6) y(1:1e6) z(1:1e6)];
start=zeros(3,3);

covxyz=cov(A);
[Vxyz2,D]=eig(covxyz)
Vxyz=Vxyz2;
Vxyz(:,1)=Vxyz2(:,2);
Vxyz(:,2)=Vxyz2(:,3);
Vxyz(:,3)=Vxyz2(:,1);

Vxyz

figure(7)
%quiver3(start(:,1),start(:,2),start(:,3),Vxyz(:,1),Vxyz(:,2),Vxyz(:,3));
quiver3(start(1,:),start(2,:),start(3,:),Vxyz(1,:),Vxyz(2,:),Vxyz(3,:));

B=A*Vxyz;

covxyz=cov(B);
[VB,~]=eig(covxyz);

hold on
%quiver3(start(:,1),start(:,2),start(:,3),VB(:,1),VB(:,2),VB(:,3));
quiver3(start(1,:),start(2,:),start(3,:),VB(1,:),VB(2,:),VB(3,:));
hold off

%{
B=A*Vxyz;

R=[1,sqrt(2)/2,0;-sqrt(2)/2,1,0;0,0,1];
C=B*R;
%}
%{
fid = fopen('D:\Adam\Optical_tweezers\01_H2O_Si_1.01um_ND1_1MHz_decorr.txt','w');
fwrite(fid,B','bit16');
fclose(fid);
toc

fid = fopen('D:\Adam\Optical_tweezers\01_H2O_Si_1.01um_ND1_1MHz_corr_xy.txt','w');
fwrite(fid,C','bit16');
fclose(fid);
%}

X=-10:0.1:10;
Y=-10:0.1:10;

hXY=hist3([A(1:1e6,1) A(1:1e6,2)] /202.3, {X Y});
hXZ=hist3([A(1:1e6,1) A(1:1e6,3)]/202.3, {X Y});
hYZ=hist3([A(1:1e6,2) A(1:1e6,3)]/202.3, {X Y});

covxy=cov([A(1:1e6,1) A(1:1e6,2)]);
[Vxy D]=eig(covxy);
covxz=cov([A(1:1e6,1) A(1:1e6,3)]);
[Vxz D]=eig(covxz);
covyz=cov([A(1:1e6,2) A(1:1e6,3)]);
[Vyz D]=eig(covyz);


figure(1)
contour(X,Y,hXY)
hold on
%plotv(Vxy)
hold off

figure(2)
contour(X,Y,hXZ)
hold on
%plotv(Vxz)
hold off

figure(3)
contour(X,Y,hYZ)
hold on
%plotv(Vyz)
hold off


hXY=hist3([B(1:1e6,1) B(1:1e6,2)] /202.3, {X Y});
hXZ=hist3([B(1:1e6,1) B(1:1e6,3)]/202.3, {X Y});
hYZ=hist3([B(1:1e6,2) B(1:1e6,3)]/202.3, {X Y});

covxy=cov([B(1:1e6,1) B(1:1e6,2)]);
[Vxy D]=eig(covxy);
covxz=cov([B(1:1e6,1) B(1:1e6,3)]);
[Vxz D]=eig(covxz);
covyz=cov([B(1:1e6,2) B(1:1e6,3)]);
[Vyz D]=eig(covyz);


figure(4)
contour(X,Y,hXY)
hold on
%plotv(Vxy)
hold off

figure(5)
contour(X,Y,hXZ)
hold on
%plotv(Vxz)
hold off

figure(6)
contour(X,Y,hYZ)
hold on
%plotv(Vyz)
hold off
%{
hXY=hist3([C(1:1e6,1) C(1:1e6,2)] /202.3, {X Y});
hXZ=hist3([C(1:1e6,1) C(1:1e6,3)]/202.3, {X Y});
hYZ=hist3([C(1:1e6,2) C(1:1e6,3)]/202.3, {X Y});

covxy=cov([C(1:1e6,1) C(1:1e6,2)]);
[Vxy D]=eig(covxy);
covxz=cov([C(1:1e6,1) C(1:1e6,3)]);
[Vxz D]=eig(covxz);
covyz=cov([C(1:1e6,2) C(1:1e6,3)]);
[Vyz D]=eig(covyz);


figure(7)
contour(X,Y,hXY)
hold on
%plotv(Vxy)
hold off

figure(8)
contour(X,Y,hXZ)
hold on
%plotv(Vxz)
hold off

figure(9)
contour(X,Y,hYZ)
hold on
%plotv(Vyz)
hold off

%}