function out = making_avi(ts,dim,first_comp,second_comp,third_comp,flyname,length1,length2)

cd('C:\Users\Students\Desktop')

atr=figure()
color_line3(first_comp,second_comp,third_comp,linspace(0,1,length(first_comp)))
title(flyname)

%% Rotation of the whole traces in the three first components of the
%%%% embedded time series

for i=1:length1
    view(0+i*2,0)
%     pause(0.01)
    drawnow
    F(i)=getframe(atr);
end
for i=(length1+1):(2*length1)
    view(180,0+i*2)
    drawnow
%     pause(0.01)
    F(i)=getframe(atr);
end
s1 = flyname;
s2 = '.avi';
s = strcat(s1,s2)
video= VideoWriter(s,'MPEG-4')
open(video)
writeVideo(video,F)
close(video)
%{
%% Following step by step the traces in the three first components of the
%%%% embedded time series

atr2=figure()
curve=animatedline('LineWidth',2);
view(43,24);
hold on;
grid on;
title(flyname)

for i=1:length2
    addpoints(curve,first_comp(i),second_comp(i),third_comp(i));
    head= scatter3(first_comp(i),second_comp(i),third_comp(i),'filled','MarkerFaceColor','b','MarkerEdgeColor','b');
    drawnow
    T(i)=getframe(atr2);
%     pause(0.01)
    delete(head)
    
end

s2 = '_dynamic.avi';
s = strcat(s1,s2);
video= VideoWriter(s,'MPEG-4');
open(video);
writeVideo(video,T)
close(video)
%}
%% Plotting embedded traces together with the mapping in the first three
%%%% components

all=figure()
ax1 = subplot(2,1,1);
% ylim([-50 20]);
title(ax1,flyname)
atr2 = subplot(2,1,2);
xlabel('first PC')
ylabel('second PC')
zlabel('third PC')
% xlim([0.4 0.6]);
% ylim([0.4 0.6]);
% zlim([0.4 0.6]);
title(atr2,strcat('mapping ',flyname))
curve=animatedline('LineWidth',2);
view(43,24);
hold on;
grid on;

minx=min(first_comp);
maxx=max(first_comp);
ran=range(first_comp);
minx2=min(second_comp);
maxx2=max(second_comp);
ran2=range(second_comp);
minx3=min(third_comp);
maxx3=max(third_comp);
ran3=range(third_comp);

%inner indices: (406:455)
%down spikes:450:560
%up spikes:150:300
where_loop=2310:2560;
for i=where_loop
    first_comp_norm=(first_comp(i)-minx)/ran;
    second_comp_norm=(second_comp(i)-minx2)/ran2;
    third_comp_norm=(third_comp(i)-minx3)/ran3;
    addpoints(curve,first_comp_norm,second_comp_norm,third_comp_norm); 
    head= scatter3(atr2,first_comp_norm,second_comp_norm,third_comp_norm,'filled','MarkerFaceColor',[first_comp_norm,second_comp_norm,third_comp_norm],'MarkerEdgeColor',[first_comp_norm,second_comp_norm,third_comp_norm]);
    plot(ax1,ts(where_loop));
    line(ax1,[i-where_loop(1) i-where_loop(1)],[-400 1000],'Color',[1 0 0]);
    line(ax1,[i+(dim-1)-where_loop(1) i+(dim-1)-where_loop(1)],[-400 1000],'Color',[1 0 0]);
    title(ax1,strcat('trace ',flyname))
%     ylim(ax1,[-50 20]);
    drawnow
    pause(0.1);
    T(i-(where_loop(1)-1))=getframe(all);
    
%     delete(head)
    
end
s1=flyname
s2 = '_sliding_window';
s = strcat(s1,s2);
video= VideoWriter(s,'MPEG-4');
video.FrameRate=5;
open(video);
writeVideo(video,T)
close(video)

%{
ranges=linspace(min(VarName1),max(VarName1),5);

for oo=1:length(VarName1)
    if (ranges(1)<VarName1(oo)<ranges(2))
        trace_color(i)='red';
    elseif (ranges(2)<VarName1(oo)<ranges(3))
        trace_color(i)='black';
    elseif (ranges(3)<VarName1(oo)<ranges(4))
        trace_color(i)='green';
    end
end

%}