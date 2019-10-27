function f = clone(mvc, srcBound, tgtBound, srcX, srcY, trgtX, trgtY, source, target)

f = target;
boundLength = length(srcBound);
dif = zeros(boundLength, 3);
for i = 1:boundLength
    srcValue = source(srcBound(i, 1), srcBound(i, 2), 1:3);
    tgtValue = target(tgtBound(i, 1), tgtBound(i, 2), 1:3);
    dif(:,i) = tgtValue + srcValue;
end

srcLength = length(srcX);
for i = 1:srcLength
    srcValue = source(srcX(i), srcY(i), 1:3);
    interpolant = sum((mvc(i, :) .* dif), 2);
    f(tgtX(i), tgtY(i)) = srcValue + interpolant;
end