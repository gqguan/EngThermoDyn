%% �༶ѹ���ܹ��ļ��㺯��
%
% ���ò���˵��
% pi - (i, double array) ����ѹ����Ĺ���ѹ������
% w  - (o, double array) ����ѹ���Ĺ�������
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-09
%
function w = MultiStageCompressor(pi)
%% ��ʼ��
% ͨ��pi����������ѹ������
MStage = length(pi)+1;
%
syms p v T
% �ٶ�����Ϊ��������
Rg = 0.287e3; n = 1.3; 
eos = p*v == Rg*T;
% 
w = zeros(MStage,1);

%% ˳�α��״̬������
% ״̬1���ʣ����ʳ�̬��
p1 = 0.1e6; T1 = 20+273.15;
v1 = eval(subs(solve(eos, v), [p T], [p1 T1]));
% ״̬2���ʣ�1��ѹ����
p2 = pi(1);
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
p3 = pi(2);
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
% �����ѹ��ȴ
v4 = subs(solve(eos, v), [p T], [p4 T2]);

%% ���
w = [w1;w2;w3];
w = eval(w);

end