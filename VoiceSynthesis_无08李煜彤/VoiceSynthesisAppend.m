clear all, close all, clc;

a1 = 1.3789;
a2 = -0.9506;
a = [1, -a1, -a2];
b = [1, 0, 0];
sys = tf([1, -a1, -a2],[1, 0, 0]);
figure;
zplane(b,a);            % 零极点图
figure;
freqz(b,a);             % 频率响应
figure;
impz(b,a);              % 单位样值响应

% 第1问
x1 = zeros(400,1);
x1(1) = 1;
n = 1:1:400;
figure;
y1 = filter(b,a,x1);
stem(n,y1);

% 第7问
x2 = generate_signal1(8000, 1, 200);
x3 = generate_signal1(8000, 1, 300);
sound([x2;x3],8000);

% 第8问 第9问
x4 = generate_signal2(1, 8000);
y4 = filter(b,a,x4);
pause(3);
sound([x4;y4],8000);

% 第12问
[r,p,k] = residue(b,a);
p_angle = angle(p(1))*1150/1000;
p(1)=abs(p(1))*exp(1i*p_angle);
p(2)=abs(p(2))*exp(-1i*p_angle);
[~,a1]=residue(r,p,k);
zplane(b,a1);
