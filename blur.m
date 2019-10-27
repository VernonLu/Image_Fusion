function f = blur(image, width)

[row, col, layer] = size(image);
temp = zeros(row + 2, col + 2);
temp(2:row + 1, 2:col + 1) = image(:, :, 4);
result = zeros(row, col);
se1 = strel('disk', 2);
for i = 1:width
    temp = imerode(temp, se1);
    result = result + temp(2:row + 1, 2:col + 1);
end
result = result / width;

f = result;