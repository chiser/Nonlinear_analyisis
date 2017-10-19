rqa_stat = zeros(6,2*size(data{1,2}.times,2));
emb_dim=zeros(1,size(data{1,2}.times,2));

for i=1:size(data{1,2}.times,2)
    detrended_ts = diff(data{1,2}.times(:,i));
    tau=1;
    mmax=15;
%     dim=11;
%     [tau,bin,mi] = estimate_tau(detrended_ts,0);
%     mi2 = mutual(detrended_ts,bin,tau+10);

    [E1 E2 dim] = cao_deneme(detrended_ts,tau,mmax);

    v = embed1( detrended_ts, dim, tau );
    emb_dim(i)=dim;
    % out=false_nearest(detrended_ts,1,mmax,1);
    % find(out(:,2)==min(out(:,2)))
    % fnn = out(:,1:2);
    % figure('Position',[100 400 460 360]);
    % plt=plot(fnn(:,1),fnn(:,2),'o-','MarkerSize',4.5);
    % title('False nearest neighbor test','FontSize',10,'FontWeight','bold');
    % xlabel('dimension','FontSize',10,'FontWeight','bold');
    % ylabel('FNN','FontSize',10,'FontWeight','bold');
    % get(gcf,'CurrentAxes');
    % set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
    % grid on;


    % phase space plot
    y = phasespace(detrended_ts,dim,tau);
    % figure('Position',[100 400 460 360]);
    % plot3(y(:,1),y(:,2),y(:,3),'-','LineWidth',1);
    % title('EKG time-delay embedding - state space plot','FontSize',10,'FontWeight','bold');
    % grid on;
    % set(gca,'CameraPosition',[25.919 27.36 13.854]);
    % xlabel('x(Rt)','FontSize',10,'FontWeight','bold');
    % ylabel('x(t+\tau)','FontSize',10,'FontWeight','bold');
    % zlabel('x(t+2\tau)','FontSize',10,'FontWeight','bold');
    % set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');

    % color recurrence plot
    %cerecurr_y(y);
    size_rec=15000;
    recurdata = cerecurr_y(y(1:size_rec,:));
    % black-white recurrence plot
    %tdrecurr_y(recurdata,0.3);
%     imagesc(recurdata)
    % colormap(gray)
%     colorbar
    %
    thres_rec=mean(recurdata(:))-(1.5*std(recurdata(:)));
    thres_rec2=mean(recurdata(:));
    x = tdrecurr_y(recurdata,thres_rec);
    %     x = tdrecurr_y(recurdata,14);
    %    figure('Position',[100 100 550 400]);
    %    plot(x(:,1),x(:,2),'k.','MarkerSize',2);
    %    xlim([0,size_rec]);
    %    ylim([0,size_rec]);
    %    xlabel('Time Index','FontSize',10,'FontWeight','bold');
    %    ylabel('Time Index','FontSize',10,'FontWeight','bold');
    %    title('Recurrence Plot','FontSize',10,'FontWeight','bold');
    %    get(gcf,'CurrentAxes');
    %    set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
        %grid on;
    %Recurrence quantification analysis
    % rqa_stat - RQA statistics - [recrate DET LMAX ENT TND LAM TT]
    rqa_stat(1:6,2*i-1) = recurrqa_y(x);
    x = tdrecurr_y(recurdata,thres_rec2);
    rqa_stat(1:6,2*i) = recurrqa_y(x);
    %}
end