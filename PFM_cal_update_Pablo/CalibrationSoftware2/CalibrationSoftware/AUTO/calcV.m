%
% Calculates array and positions of modulation fuction (getV)
% for a array x which is read element by element
%
function [vArray iArray] = calcV(x)
  maximum = x(1);
  minimum = x(1);
  x0 = x(1);
  vValue0 = getV([x(1)]);
  vArray = [vValue0];
  iArray = [1];
  for i=2:length(x)-1
    a = [x0 x(i)];
    vArray = [vArray getV(a)];
    iArray = [iArray i];
    x0 = a;
  end
 end
 