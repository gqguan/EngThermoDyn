%% �༶ѹ���ܹ��ļ��㺯��
%
% ���ò���˵��
% pi - (i, double array) ����ѹ����Ĺ���ѹ������
% w  - (o, double array) ����ѹ���Ĺ�������
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-09
%
function wval = MultiStageCompressor(pi)
%% ��ʼ��
% ͨ��pi����������ѹ������
MStage = length(pi)+1;
NState = length(pi)+2;
%
syms p v T
% �ٶ�����Ϊ��������
Rg = 0.287e3; n = 1.3; 
eos = p*v == Rg*T;
% 
wval = zeros(MStage,1);
pval = zeros(NState,1);
vval = zeros(NState,1);
Tval = zeros(NState,1);
% ������֪����
% ��̬
pval(1) = 0.1e6; Tval(1) = 20+273.15; % ���ù��ʵ�λ����ͬ��
% �м�̬
pval(2:NState-1) = pi;
% ��̬
pval(NState) = 12.5e6;

%% ˳�α��״̬������   
% ״̬1���ʣ����ʳ�̬��
vval(1) = eval(subs(solve(eos, v), [p T], [pval(1) Tval(1)]));
for i = 1:MStage
    % ѹ��ǰ״̬
    p1 = pval(i); v1 = vval(i); T1 = Tval(i);
    % ѹ����״̬
    p2 = pval(i+1);
    % ���ʴ�״̬1ͨ�������̣�n=1.3���仯��״̬2
    syms dlnp dlnv
    eq1 = dlnp+n*dlnv == 0;
    eq1a = subs(eq1, [dlnp,dlnv], [log(p)-log(p1),log(v)-log(v1)]);
    v2 = subs(solve(eq1a, v), p, p2);
    T2 = eval(subs(solve(eos, T), [p v], [p2 v2]));
    % ѹ�����̹���
    wval(i) = -eval(int(solve(eq1a, v), p, p1, p2));
    % �����ѹ��ȴ
    v2 = subs(solve(eos, v), [p T], [p2 T2]);
    % д��״̬����
    pval(i+1) = p2;
    vval(i+1) = v2;
    Tval(i+1) = T2;
end

end