clear all;
close all;
profile on
tic
fid = fopen('D:\Adam\Optical_tweezers\01_H2O_Si_1.01um_ND1_1MHz.txt');
A=(fread(fid,[3,inf],'bit16'))';
fclose(fid);



X=-10:0.1:10;
Y=-10:0.1:10;


hXY=hist3([A(1,1:1e7)' A(2,1:1e7)'] /202.3, {X Y});
hXZ=hist3([A(1,1:1e7)' A(3,1:1e7)']/202.3, {X Y});
hYZ=hist3([A(2,1:1e7)' A(3,1:1e7)']/202.3, {X Y});

covxy=cov([A(1,1:1e6)' A(2,1:1e6)']);
[Vxy D]=eig(covxy);
covxz=cov([A(1,1:1e6)' B(A,1:1e6)']);
[Vxz D]=eig(covxz);
covyz=cov([A(2,1:1e6)' B(A,1:1e6)']);
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



covxyz=cov(A);
[Vxyz D]=eig(covxyz);

B=inv(Vxyz)*A';
%{
fid = fopen('D:\Adam\Optical_tweezers\01_H2O_Si_1.01um_ND1_1MHz_decorr.txt','w');
fwrite(fid,B,'bit16');
fclose(fid);
toc

R1=[1,sqrt(2)/2,0;sqrt(2)/2,1,0;0,0,1];
C=R1*B;
fid = fopen('D:\Adam\Optical_tweezers\01_H2O_Si_1.01um_ND1_1MHz_corr_xy.txt','w');
fwrite(fid,C,'bit16');
fclose(fid);
%}

X=-10:0.1:10;
Y=-10:0.1:10;


hXY=hist3([B(1,1:1e7)' B(2,1:1e7)'] /202.3, {X Y});
hXZ=hist3([B(1,1:1e7)' B(3,1:1e7)']/202.3, {X Y});
hYZ=hist3([B(2,1:1e7)' B(3,1:1e7)']/202.3, {X Y});

covxy=cov([B(1,1:1e6)' B(2,1:1e6)']);
[Vxy D]=eig(covxy);
covxz=cov([B(1,1:1e6)' B(3,1:1e6)']);
[Vxz D]=eig(covxz);
covyz=cov([B(2,1:1e6)' B(3,1:1e6)']);
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