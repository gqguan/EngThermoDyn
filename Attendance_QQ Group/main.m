%% ��QQȺ�������¼����ȡ�ض����Ͽδ򿨼�¼
%
% by Dr. GUAN, Guoqiang @ SCUT on 2020/03/09
%
clear;
%% ��QQȺ�����¼txt�ļ��е��������ֶ�������ʽ����MATLAB�����ռ�
import_log;
% Delete the first six rows
QQGroup_log(1:6) = [];
%
%% ˳��ɨ�蹤���ռ��ļ�����ȡ��Ч���ݼ�¼
% ��ʼ��
line_num = length(QQGroup_log);
log_sn = 0;
i = 1;
while i<(line_num)
    % ɨ���i��
    content = textscan(QQGroup_log(i),'%s');
    content = content{:};    
    if length(content) == 3 && length(content{1}) == 10 && length(content{2}) == 8
        % ��ʶ����Ϊheader
        log_sn = log_sn+1;
        dates(log_sn) = textscan(content{1},'%D');
        times(log_sn) = textscan(content{2},'%D');
        users(log_sn) = textscan(content{3},'%s');
        user_infocell = users(log_sn);
        user_infocell = user_infocell{:};
        chk_bracket = strfind(user_infocell,'(');
        if isempty(chk_bracket{:})
            fprintf('No bracket found in line %d: %s\n',i, user_infocell{:})
        else
            BracketNumber = extractBetween(user_infocell,'(',')');
            QQNum(log_sn) = BracketNumber(end);
        end
    else
        contents(log_sn) = cellstr(QQGroup_log(i));
    end
    i = i+1;
end
contents(log_sn) = cellstr(QQGroup_log(i));
dates = dates'; times = times'; users = users'; contents = contents'; QQNum = QQNum';
log_tab = table(dates,times,QQNum, users,contents);