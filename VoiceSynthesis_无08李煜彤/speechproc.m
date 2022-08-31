function speechproc()

    % ���峣��
    FL = 80;                % ֡��
    WL = 240;               % ����
    P = 10;                 % Ԥ��ϵ������
    s = readspeech('voice.pcm',100000);             % ��������s
    L = length(s);          % ������������
    FN = floor(L/FL)-2;     % ����֡��
    % Ԥ����ؽ��˲���
    exc = zeros(L,1);       % �����źţ�Ԥ����
    zi_pre = zeros(P,1);    % Ԥ���˲�����״̬
    s_rec = zeros(L,1);     % �ؽ�����
    zi_rec = zeros(P,1);    % �ؽ��˲�����״̬
    % �ϳ��˲���
    exc_syn = zeros(L,1);   % �ϳɵļ����źţ����崮��
    s_syn = zeros(L,1);     % �ϳ�����
    zi_syn = zeros(P,1);    % �ϳ��˲�����״̬
    % ����������˲���
    exc_syn_t = zeros(L,1);   % �ϳɵļ����źţ����崮��
    s_syn_t = zeros(L,1);     % �ϳ�����
    zi_syn_t = zeros(P,1);    % �ϳ��˲�����״̬
    % ���ٲ�����˲����������ٶȼ���һ����
    exc_syn_v = zeros(2*L,1);   % �ϳɵļ����źţ����崮��
    s_syn_v = zeros(2*L,1);     % �ϳ�����
    zi_syn_v = zeros(P,1);      % �ϳ��˲�����״̬

    hw = hamming(WL);       % ������
    
    % ���δ���ÿ֡����
    for n = 3:FN

        % ����Ԥ��ϵ��������Ҫ���գ�
        s_w = s(n*FL-WL+1:n*FL).*hw;    %��������Ȩ�������
        [A E] = lpc(s_w, P);            %������Ԥ�ⷨ����P��Ԥ��ϵ��
                                        % A��Ԥ��ϵ����E�ᱻ��������ϳɼ���������

        if n == 27
        % (3) �ڴ�λ��д���򣬹۲�Ԥ��ϵͳ���㼫��ͼ
            figure;
            zplane(A, 1);
        end
        
        s_f = s((n-1)*FL+1:n*FL);       % ��֡�����������Ҫ����������

        % (4) �ڴ�λ��д������filter����s_f���㼤����ע�Ᵽ���˲���״̬

        [exc((n-1)*FL+1:n*FL), zi_pre] = filter(A, 1, s_f, zi_pre);

        % (5) �ڴ�λ��д������filter������exc�ؽ�������ע�Ᵽ���˲���״̬

        [s_rec((n-1)*FL+1:n*FL), zi_rec] ...
            = filter(1, A, exc((n-1)*FL+1:n*FL), zi_rec);

        % ע������ֻ���ڵõ�exc��Ż������ȷ
        s_Pitch = exc(n*FL-222:n*FL);
        PT = findpitch(s_Pitch);    % �����������PT����Ҫ�����գ�
        G = sqrt(E*PT);           % ����ϳɼ���������G����Ҫ�����գ�

        % (10) �ڴ�λ��д�������ɺϳɼ��������ü�����filter���������ϳ�����
        k = 2*FL + 1;
        while k <= n*FL
            exc_syn(k) = G;
            k = k + PT;
        end
        
        [s_syn((n-1)*FL+1:n*FL), zi_syn] = ...
            filter(1, A, exc_syn((n-1)*FL+1:n*FL), zi_syn);       

        % (11) ���ı�������ں�Ԥ��ϵ�������ϳɼ����ĳ�������һ��������Ϊfilter
        % ������õ��µĺϳ���������һ���ǲ����ٶȱ����ˣ�������û�б䡣
        
        FL_v = 2*FL;
        k = 2*FL_v + 1;
        while k < n*FL_v
            exc_syn_v(k) = G;
            k = k + PT;
        end
        [s_syn_v((n-1)*FL_v+1:n*FL_v), zi_syn_v] = ...
            filter(1, A, exc_syn_v((n-1)*FL_v+1:n*FL_v), zi_syn_v);
        
        % (13) ���������ڼ�Сһ�룬�������Ƶ������150Hz�����ºϳ�������������ɶ���ܡ�
        % �����Ƶ������150Hz
        [r,p,k] = residue(1,A);
        ang = 150*2*pi/8000;
        p = p.*exp(1i*ang*sign(imag(p)));
        [~,A1] = residue(r,p,k);
        
        k = 2*FL + 1;
        while k <= n*FL
            exc_syn_t(k) = G;
            k = k + round(PT/2);
        end        
           
        [s_syn_t((n-1)*FL+1:n*FL), zi_syn_t] = ...
            filter(1, A1, exc_syn_t((n-1)*FL+1:n*FL), zi_syn_t);        
        
    end

    % (6) �ڴ�λ��д������һ�� s ��exc �� s_rec �к����𣬽�����������
    % ��������������ĿҲ������������д���������ر�ע��
    
    % ԭʼ����
    sound(s/max(abs(s)),8000);
    pause(2);
    
    % �����ź�
    sound(exc/max(abs(exc)),8000);
    pause(2);
    
    % �ؽ�����
    sound(s_rec/max(abs(s_rec)),8000);
    pause(2);
    
    % �ϳ�����
    sound(s_syn/max(abs(s_syn)),8000);
    pause(2);
    
    % ���ٲ����
    sound(s_syn_v/max(s_syn_v),8000);
    pause(4);
    
    % ���������
    sound(s_syn_t/max(s_syn_t),8000);
    
    % ���������ļ�
    writespeech('exc.pcm',exc);
    writespeech('rec.pcm',s_rec);
    writespeech('exc_syn.pcm',exc_syn);
    writespeech('syn.pcm',s_syn);
    writespeech('exc_syn_t.pcm',exc_syn_t);
    writespeech('syn_t.pcm',s_syn_t);
    writespeech('exc_syn_v.pcm',exc_syn_v);
    writespeech('syn_v.pcm',s_syn_v);
return

% ��PCM�ļ��ж�������
function s = readspeech(filename, L)
    fid = fopen(filename, 'r');
    s = fread(fid, L, 'int16');
    fclose(fid);
return

% д������PCM�ļ���
function writespeech(filename,s)
    fid = fopen(filename,'w');
    fwrite(fid, s, 'int16');
    fclose(fid);
return

% ����һ�������Ļ������ڣ���Ҫ������
function PT = findpitch(s)
[B, A] = butter(5, 700/4000);
s = filter(B,A,s);
R = zeros(143,1);
for k=1:143
    R(k) = s(144:223)'*s(144-k:223-k);
end
[R1,T1] = max(R(80:143));
T1 = T1 + 79;
R1 = R1/(norm(s(144-T1:223-T1))+1);
[R2,T2] = max(R(40:79));
T2 = T2 + 39;
R2 = R2/(norm(s(144-T2:223-T2))+1);
[R3,T3] = max(R(20:39));
T3 = T3 + 19;
R3 = R3/(norm(s(144-T3:223-T3))+1);
Top = T1;
Rop = R1;
if R2 >= 0.85*Rop
    Rop = R2;
    Top = T2;
end
if R3 > 0.85*Rop
    Rop = R3;
    Top = T3;
end
PT = Top;
return