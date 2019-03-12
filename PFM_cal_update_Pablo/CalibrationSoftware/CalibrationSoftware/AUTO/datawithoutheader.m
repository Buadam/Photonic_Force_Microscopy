%%%%%%%%%%%%%%%%%%
% Reads file without the header
%%%%%%%%%%%%%%%%%%    
function m = datawithoutheader(filename) 
	%Last arguments skip the header
      	m0 = dlmread(filename,'\t',1,0);
	files=length(m0(:,1));
	columns=length(m0(1,:));
	m = m0(1:files,1:columns);
end
