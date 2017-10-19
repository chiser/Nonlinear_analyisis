ts=data{1,1}.times(:,2);
detrended_ts = diff(ts);
tau=1
mmax=20
% dim=10
% fly1=data{1,1}.times(:,1);
% save firstfly_bjoern.txt fly1 -ascii

[E1 E2 dim] = cao_deneme(detrended_ts,tau,mmax);

v = embed1( detrended_ts, dim, tau );
%% Make a PCA to visualize the 12 dimensions

[coeff,score,latent,tsquared] = pca(v);

% bar(latent)

first_comp=score(:,1)'*v;
second_comp=score(:,2)'*v;
third_comp=score(:,3)'*v;
%fourth_comp=score(:,4)'*v;

% figure()
% plot(first_comp,second_comp)

% figure()
% plot3(first_comp,second_comp,third_comp)

% figure()
% plot3(first_comp,second_comp,1:length(first_comp))

% figure()
% color_line3(first_comp(1:2000),second_comp(1:2000),third_comp(1:2000),linspace(0,1,length(first_comp(1:2000))))

figure()
color_line3(first_comp,second_comp,third_comp,linspace(0,1,length(first_comp)))
% xlabel('first')
% ylabel('second')
% figure()
% color_line3(detrended_ts(1:(end-3)),detrended_ts(2:(end-2)),detrended_ts(3:(end-1)),linspace(0,1,length(detrended_ts(1:(end-3)))))

flyname='fly2_bjoern_5dims'
making_avi(ts,dim,first_comp,second_comp,third_comp,flyname,90,400)

out=false_nearest(detrended_ts,1,13,1);
fnn = out(:,1:2);
figure('Position',[100 400 460 360]);
plt=plot(fnn(:,1),fnn(:,2),'o-','MarkerSize',4.5);
title('False nearest neighbor test','FontSize',10,'FontWeight','bold');
xlabel('dimension','FontSize',10,'FontWeight','bold');
ylabel('FNN','FontSize',10,'FontWeight','bold');
get(gcf,'CurrentAxes');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
grid on;


% phase space plot
y = phasespace(detrended_ts,11,1);
figure('Position',[100 400 460 360]);
plot3(y(:,1),y(:,2),y(:,3),'-','LineWidth',1);
title('EKG time-delay embedding - state space plot','FontSize',10,'FontWeight','bold');
grid on;
set(gca,'CameraPosition',[25.919 27.36 13.854]);
xlabel('x(t)','FontSize',10,'FontWeight','bold');
ylabel('x(t+\tau)','FontSize',10,'FontWeight','bold');
zlabel('x(t+2\tau)','FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');

% color recurrence plot
%cerecurr_y(y);
recurdata = cerecurr_y(y(1:5000,:));
first_recur=recurdata(1:5000,1:5000);
% black-white recurrence plot
%tdrecurr_y(recurdata,0.3);
x = tdrecurr_y(recurdata,3);

    figure('Position',[100 100 550 400]);
    plot(x(:,1),x(:,2),'k.','MarkerSize',2);
    xlim([0,m]);
    ylim([0,n]);
    xlabel('Time Index','FontSize',10,'FontWeight','bold');
    ylabel('Time Index','FontSize',10,'FontWeight','bold');
    title('Recurrence Plot','FontSize',10,'FontWeight','bold');
    get(gcf,'CurrentAxes');
    set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
    %grid on;

%Recurrence quantification analysis
% rqa_stat - RQA statistics - [recrate DET LMAX ENT TND LAM TT]
rqa_stat = recurrqa_y(x)