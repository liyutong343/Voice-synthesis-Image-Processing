function [DC_code,AC_code,H,W] = compress(img)
load JpegCoeff.mat QTAB;

im = double(img)-128;
% 补全图片大小为8的倍数大小
[h,w] = size(im);
H = ceil(h/8)*8;
W = ceil(w/8)*8;
img = zeros(H,W);
img(1:h,1:w)=im;

h_seq = H/8;
w_seq = W/8;
result = zeros(64,h_seq*w_seq);
count = 1;
for i = 1:h_seq
    for j = 1:w_seq
        cur = img(i*8-7:i*8,j*8-7:j*8); % 截取
        cur = dct2(cur);                % DCT
        cur = round(cur./QTAB);         % 量化
        cur = (zigzag(cur))';           % zigzag扫描
        result(:,count) = cur;          % 排列
        count = count+1;
    end
end

cD = result(1,:);
[~,s] = size(cD);
cD_pre_err = zeros(1,s);
cD_pre_err(1) = cD(1);
for i = 2:1:s
    cD_pre_err(i) = cD(i-1)-cD(i);
end

% 找到Category
Category = zeros(1,s);
for i = 1:1:s
    if cD_pre_err(i)==0
        Category(i) = 0;
    else
        Category(i) = floor(log2(abs(cD_pre_err(i))))+1;
    end
end

% 拼接
DC_code = Huffman(Category(1));
DC_code = [DC_code,complement(cD_pre_err(1))];
for i = 2:1:s
    DC_code = [DC_code,Huffman(Category(i))];
    DC_code = [DC_code,complement(cD_pre_err(i))];
end

% AC系数
AC_code = [];
for i = 1:1:s
    ac = result(2:64,i);

    % 先记下所有非零的数的位置
    non_zero = 0;
    for j = 1:1:63
        if(ac(j)~=0)
            non_zero = cat(2,non_zero,j);
        end
    end
    [~,non_zero_num] = size(non_zero);
    non_zero_num = non_zero_num-1;  % 非零数字的个数

    if non_zero_num == 0
        % 全是0
        AC_code = cat(2,AC_code,[1 0 1 0]);
    else
        for j = 2:1:non_zero_num+1
            % 前面有多少个0
            Run = non_zero(j)-non_zero(j-1)-1;
            while Run>=16
                AC_code = cat(2,AC_code,[1 1 1 1 1 1 1 1 0 0 1]);
                Run = Run - 16;
            end
            cur = non_zero(j);
            Size = floor(log2(abs(ac(cur))))+1;
            achuff = ACHuffman(Run,Size);
            AC_code = cat(2,AC_code,achuff);
            AC_code = cat(2,AC_code,complement(ac(cur)));
        end
        AC_code = cat(2,AC_code,[1 0 1 0]);    % EOB
    end
end
end

