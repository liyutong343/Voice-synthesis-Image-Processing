function u = get_u(img,L)
% 获取图象的特征向量
    N = 2^(3*L);
    [H,W,~] = size(img);
    num_pix = H*W;
    
    u = zeros(N,1);
    for j = 1:1:H
        for k = 1:1:W
            color=img(j,k,:);
            R = floor(color(1)/2^(8-L));
            G = floor(color(2)/2^(8-L));
            B = floor(color(3)/2^(8-L));
            n = R*2^(2*L)+G*2^L+B;
            u(n+1) = u(n+1)+1;
        end
    end
    u = u/num_pix;
end

