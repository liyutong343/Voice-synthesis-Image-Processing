function achuff= ACHuffman(Run,Size)
load JpegCoeff.mat ACTAB

% 找到这一行
line = 0;
for i = 1:1:160
    if ACTAB(i,1) == Run && ACTAB(i,2) == Size
        line = i;
        break;
    end
end

s = ACTAB(line,3);
achuff = ACTAB(line,4:4+s-1);

end

