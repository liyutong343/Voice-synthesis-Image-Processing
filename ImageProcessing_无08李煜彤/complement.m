function com= complement(num)
%   生成num的补码
%   位数尽量少，因此正数首位为1，负数首位为0

if num == 0
    com = [];
    return;
end

% 变为2进制
bin = dec2bin(abs(num));
[~,s] = size(bin);

% 字符串变数组
com = zeros(1,s);
for i = 1:1:s
    com(i) = str2num(bin(i));
end

% 取1-补码
if num < 0
    for i = 1:1:s
        com(i) = 1-com(i);
    end
end

end

