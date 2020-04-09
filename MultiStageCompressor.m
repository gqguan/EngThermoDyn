%% 多级压缩总功耗计算函数
%
% 调用参数说明
% pi - (i, double array) 各级压缩后的工质压力向量
% w  - (o, double array) 各级压缩的功耗向量
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-09
%
function wval = MultiStageCompressor(pi)
%% 初始化
% 通过pi分量个数得压缩级数
MStage = length(pi)+1;
NState = length(pi)+2;
%
syms p v T
% 假定工质为理想气体
Rg = 0.287e3; n = 1.3; 
eos = p*v == Rg*T;
% 
wval = zeros(MStage,1);
pval = zeros(NState,1);
vval = zeros(NState,1);
Tval = zeros(NState,1);
% 代入已知条件
% 初态
pval(1) = 0.1e6; Tval(1) = 20+273.15; % 采用国际单位（下同）
% 中间态
pval(2:NState-1) = pi;
% 终态
pval(NState) = 12.5e6;

%% 顺次表达状态点性质   
% 状态1性质（工质初态）
vval(1) = eval(subs(solve(eos, v), [p T], [pval(1) Tval(1)]));
for i = 1:MStage
    % 压缩前状态
    p1 = pval(i); v1 = vval(i); T1 = Tval(i);
    % 压缩后状态
    p2 = pval(i+1);
    % 工质从状态1通过多变过程（n=1.3）变化到状态2
    syms dlnp dlnv
    eq1 = dlnp+n*dlnv == 0;
    eq1a = subs(eq1, [dlnp,dlnv], [log(p)-log(p1),log(v)-log(v1)]);
    v2 = subs(solve(eq1a, v), p, p2);
    T2 = eval(subs(solve(eos, T), [p v], [p2 v2]));
    % 压缩过程功耗
    wval(i) = -eval(int(solve(eq1a, v), p, p1, p2));
    % 级间等压冷却
    v2 = subs(solve(eos, v), [p T], [p2 T2]);
    % 写入状态变量
    pval(i+1) = p2;
    vval(i+1) = v2;
    Tval(i+1) = T2;
end

end