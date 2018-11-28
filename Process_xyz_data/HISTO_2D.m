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