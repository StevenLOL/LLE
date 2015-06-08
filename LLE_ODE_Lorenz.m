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
tstep = 1e-2; % ʱ�䲽��
wholetimes = 1e5; % �ܵ�ѭ������
steps = 100; % ÿ���ݻ��Ĳ���
iteratetimes = wholetimes/steps; % �ݻ��Ĵ���
mod = zeros(3,1);
lyp = zeros(3,1);

% ��ʼ������Lyapunovָ��
Lyapunov1 = zeros(iteratetimes,1);
Lyapunov2 = zeros(iteratetimes,1);
Lyapunov3 = zeros(iteratetimes,1);

for i=1:iteratetimes
    
    tspan = tstart:tstep:(tstart + tstep*steps);   
    [T,Y] = ode45(@lorenz_ode, tspan, y);
    
%     h1=figure;
%     plot(T,Y(:,1),'r-',T,Y(:,2),'g-',T,Y(:,3),'b-')
%     legend('x','y','z');
%     print(gcf,'-dpng',[num2str(i),'.png'])
%     close(h1);
    
    % ȡ���ֵõ������һ��ʱ�̵�ֵ
    y = Y(size(Y,1),:);
    % ���¶�����ʼʱ��
    tstart = tstart + tstep*steps;
    y0 = [y(4) y(7) y(10);
          y(5) y(8) y(11);
          y(6) y(9) y(12)];
    %������
    [y0,znorm] = GS(y0);
    lyp = lyp + log(znorm);
    y(4:12) = y0';

    %����Lyapunovָ��
    Lyapunov1(i) = lyp(1)/(tstart);
    Lyapunov2(i) = lyp(2)/(tstart);
    Lyapunov3(i) = lyp(3)/(tstart);
end

for j=1:3
    lyp(j)=lyp(j)/tstart;
end
disp(lyp)

%   ��Lyapunovָ����ͼ
i = 1:iteratetimes;
plot(i,Lyapunov1,'r-',i,Lyapunov2,'g-',i,Lyapunov3,'b-')