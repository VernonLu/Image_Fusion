function result = Cloner(mvc, srcBound, trgtBound, srcX, srcY, trgtX, trgtY, source, target)
result = target;
bNum = length(srcBound);
iNum = length(srcX);
diff = zeros(1, bNum);
for bCount = 1:bNum
    srcValue = double(source(srcBound(bCount, 1), srcBound(bCount, 2)));
    trgtValue = double(target(trgtBound(bCount, 1), trgtBound(bCount, 2)));
    diff(1, bCount) = trgtValue - srcValue;
end
for iCount = 1:iNum
    srcValue = double(source(srcX(iCount), srcY(iCount)));
    interpolant = sum((mvc(iCount, :) .* diff), 2);
    result(trgtX(iCount), trgtY(iCount)) = srcValue + interpolant;
end