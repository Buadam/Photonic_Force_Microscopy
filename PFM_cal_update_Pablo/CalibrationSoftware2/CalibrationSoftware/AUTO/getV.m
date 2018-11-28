%
% Modulation fuction (getV) for a array x 
%
function vValue = getV(x)
 vValue = (max(x)-min(x))/(max(x)+min(x));
end