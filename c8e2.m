%% �̲ģ���5�棩��8-2
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-09
%
%% ��ʼ��
clear;
syms p v T
% �ٶ�����Ϊ��������
Rg = 0.287e3; n = 1.3; 
eos = p*v == Rg*T;

%% ˳�α��״̬������
% ״̬1���ʣ����ʳ�̬��
p1 = 0.1e6; T1 = 20+273.15;
v1 = eval(subs(solve(eos, v), [p T], [p1 T1]));
% ״̬2���ʣ�1��ѹ����
syms p2
% ���ʴ�״̬1ͨ�������̣�n=1.3���仯��״̬2
syms dlnp dlnv
eq1 = dlnp+n*dlnv == 0;
eq1a = subs(eq1, [dlnp,dlnv], [log(p)-log(p1),log(v)-log(v1)]);
v2 = subs(solve(eq1a, v), p, p2);
T2 = eval(subs(solve(eos, T), [p v], [p2 v2]));
% ѹ�����̹���
w1 = -int(solve(eq1a, v), p, p1, p2);
% �����ѹ��ȴ
v2 = subs(solve(eos, v), [p T], [p2 T2]);
% ״̬3���ʣ�2��ѹ����
syms p3
eq1b = subs(eq1, [dlnp,dlnv], [log(p)-log(p2),log(v)-log(v2)]);
v3 = subs(solve(eq1b, v), p, p3);
T3 = eval(subs(solve(eos, T), [p v], [p3 v3]));
% ѹ�����̹���
w2 = -int(solve(eq1b, v), p, p2, p3);
% �����ѹ��ȴ
v3 = subs(solve(eos, v), [p T], [p3 T2]);
% ״̬4���ʣ�3��ѹ���󣬹�����̬)
p4 = 12.5e6;
eq1c = subs(eq1, [dlnp,dlnv], [log(p)-log(p3),log(v)-log(v3)]);
v4 = subs(solve(eq1c, v), p, p4);
T4 = eval(subs(solve(eos, T), [p v], [p4 v4]));
% ѹ�����̹���
w3 = -int(solve(eq1c, v), p, p3, p4);
%% �ܹ���
w = w1+w2+w3;

%% ����С����
% Ŀ�꺯��
work = @(pval)(sum(abs(MultiStageCompressor(pval))));
% ��ֵ
pval0 = [(p4-p1)/20,(p4-p1)/5];
% ��ʹĿ�꺯����С��pvalֵ
options = optimset('PlotFcns', @optimplotfval);
[pi,w_min,exitflag] = fminsearch(work, pval0, options)
