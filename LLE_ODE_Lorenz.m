%Calculate largest Lyapunov exponent from ODE directly.
%Algorithm is based on Alan Wolf, 1985.

%By Xiaowei Huai
%2015/5/28
%------------------------------------------------------------
close all;clear;clc;
yinit = [1,1,1];
orthmatrix = [1 0 0;
              0 1 0;
              0 0 1];
y = zeros(12,1);
y(1:3) = yinit;
y(4:12) = orthmatrix;

tstart = 0; % ʱ���ʼֵ
%tstep = 1e-6; % ʱ�䲽��
%wholetimes = 1e6; % �ܵ�ѭ������
%steps = 1000; % ÿ���ݻ��Ĳ���
%iteratetimes = wholetimes/steps; % �ݻ��Ĵ���
iteratetimes = 500;
tincre = 1.2;
sum = zeros(3,1);

% ��ʼ������Lyapunovָ��
expo = zeros(iteratetimes,3);

for i=1:iteratetimes
    %tend = tstart + tstep*steps;
    %tspan = tstart:tstep:tend;   
    tend = tstart + tincre;
    [~,Y] = ode45(@lorenz_ode,[tstart,tend], y);

    % ȡ���ֵõ������һ��ʱ�̵�ֵ
    y = Y(size(Y,1),:);
    % ���¶�����ʼʱ��
    tstart = tend;
    y0 = [y(4) y(7) y(10);
          y(5) y(8) y(11);
          y(6) y(9) y(12)];
    %������
    [y0,znorm] = GS(y0);
    sum = sum + log(znorm);
    y(4:12) = y0;

    %����Lyapunovָ��
    for j=1:3
        expo(i,j) = sum(j)/tstart;
    end
end

lyap = expo(length(expo),:);
disp(lyap)

%   ��Lyapunovָ����ͼ
i = 1:iteratetimes;
plot(i,expo(:,1),'r-',i,expo(:,2),'g-',i,expo(:,3),'b-','LineWidth',1.5)
xlabel('\fontsize{14}Time');ylabel('\fontsize{14}Lyapunov Exponents')
legend('\lambda_1','\lambda_2','\lambda_3','Location','Best')
legend('boxoff')
print(gcf,'-dpng','LES.png')