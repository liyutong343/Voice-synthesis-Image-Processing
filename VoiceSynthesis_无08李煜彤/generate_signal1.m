function signal = generate_signal1(Fs, Duration, Freq)
% Fs: 抽样频率
% duration: 持续时间
% Freq: 信号频率
    
    length = round(Fs*Duration);    % 信号长度8000
    NS = round(Freq*Duration);  
    N = round(length/NS);   
    
    signal = zeros(length,1);   % 生成信号
    for k = 0:NS-1
        signal(N*k + 1) = 1;
    end
    
end
