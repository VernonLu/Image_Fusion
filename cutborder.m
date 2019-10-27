function f = cutborder(in)
[row,col,layer] = size(in);
%% Col
temp = sum(in(:,:,layer));
cutcol = find(temp);
width = length(cutcol);

%% Row
temp = sum(in(:,:,layer),2);
cutrow = find(temp); 
height = length(cutrow);

%% Output
f = in(cutrow(1):cutrow(height),cutcol(1):cutcol(width),:);
