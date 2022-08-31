function signal = generate_signal2(Duration,Fs)
%   此处显示详细说明
    length = round(Fs*Duration);
    signal = zeros(length,1);
    k = 1;
    while k <= length
        signal(k) = 1;
        m = floor(k/80) + 1;
        PT = 80 + 5 * mod(m, 50);
        k = k + PT;
    end
end

