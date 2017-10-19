detrended_ts = diff(VarName1);
mmax=13
dim=12
tau=1

[E1 E2 dim] = cao_deneme(detrended_ts,tau,mmax);

v = embed1( detrended_ts, dim, 1 );
v2 = embed1( VarName1(2:end), dim, 1 );
%% Make a PCA to visualize the 12 dimensions

[coeff,score,latent,tsquared] = pca(v);

first_comp=score(:,1)'*v;
second_comp=score(:,2)'*v;
third_comp=score(:,3)'*v;


inner_projection1=abs(first_comp)<(mean(first_comp)+std(first_comp));
inner_projection2=abs(second_comp)<(mean(second_comp)+std(second_comp));
inner_projection3=abs(third_comp)<(mean(third_comp)+std(third_comp));

inner_projection=inner_projection1 & inner_projection2 & inner_projection3;

in_indices=find(inner_projection);

traces_projection_registration=zeros(1,length(detrended_ts));
for i=1:length(in_indices)
   traces_projection_registration(in_indices(i):in_indices(i)+(dim-1))=traces_projection_registration(in_indices(i):in_indices(i)+(dim-1))+1; 
end

% Find points above the level
above2 = (traces_projection_registration>=2);
above4 = (traces_projection_registration>=4);
above8 = (traces_projection_registration>=8);
above10 = (traces_projection_registration>=10);
% Create 2 copies of y
in = VarName1(2:end);
transition_in = VarName1(2:end);
transition = VarName1(2:end);
transition_out = VarName1(2:end);
out = VarName1(2:end);
% Set the values you don't want to get drawn to nan
in(~above10) = NaN;
transtion_in(~above8 | above10) = NaN;
transition(~above4 | above8) = NaN;
transition_out(~above2 | above4) = NaN;
out(above2) = NaN;

figure()
plot(1:length(detrended_ts),in,'Color',[0.9 0 0]);
hold on
plot(1:length(detrended_ts),transition_in,'Color',[0.7 0 0]);
plot(1:length(detrended_ts),transition,'Color',[0 0 0.7]);
plot(1:length(detrended_ts),transition_out,'Color',[0 0.5 0]);
plot(1:length(detrended_ts),out,'Color',[0 0.7 0]);
hold off
legend('inner','transition in','transition','transition out','out')
title('8v coloured traces')


inner_traces = VarName1(2:end);
inner_ind=find(inner_traces(above4));
chunks=abs(diff(inner_ind));
chunksize=find(chunks ~= 1);
biggest_chunk=diff(chunksize);

big_chunk_ind=chunksize(find(biggest_chunk==max(biggest_chunk)));

plot(VarName1(big_chunk_ind:(big_chunk_ind+max(biggest_chunk))))
plot(VarName1)

in_proj=find(inner_projection);
chunk_size=diff(find(diff(in_proj)~=1));
big_chunks=find(chunk_size>50);
chunk_size(big_chunks(1))
a=find(diff(in_proj)~=1);
a(big_chunks(1)):(a(big_chunks(1))+chunk_size(big_chunks(1)))

%% Plotting embedded traces together with the mapping in the first three
%%%% components

all=figure()
ax1 = subplot(2,1,1);
% ylim([-50 20]);
title(ax1,'trace 8v')
atr2 = subplot(2,1,2);
xlabel('first PC')
ylabel('second PC')
zlabel('third PC')
% xlim([0.4 0.6]);
% ylim([0.4 0.6]);
% zlim([0.4 0.6]);
title(atr2,'mapping 8v')
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
where_loop=310:560;
for i=where_loop
    first_comp_norm=(first_comp(i)-minx)/ran;
    second_comp_norm=(second_comp(i)-minx2)/ran2;
    third_comp_norm=(third_comp(i)-minx3)/ran3;
    addpoints(curve,first_comp_norm,second_comp_norm,third_comp_norm); 
    head= scatter3(atr2,first_comp_norm,second_comp_norm,third_comp_norm,'filled','MarkerFaceColor',[first_comp_norm,second_comp_norm,third_comp_norm],'MarkerEdgeColor',[first_comp_norm,second_comp_norm,third_comp_norm]);
    plot(ax1,ts(where_loop));
    line(ax1,[i-where_loop(1) i-where_loop(1)],[-30 30],'Color',[1 0 0]);
    line(ax1,[i+(dim-1)-where_loop(1) i+(dim-1)-where_loop(1)],[-30 30],'Color',[1 0 0]);
    title(ax1,'trace 8v')
%     ylim(ax1,[-50 20]);
    drawnow
    pause(0.1);
    T(i-(where_loop(1)-1))=getframe(all);
    
%     delete(head)
    
end
s1='8v'
s2 = '_sliding_window.avi';
s = strcat(s1,s2);
video= VideoWriter(s,'MPEG-4');
video.FrameRate=5;
open(video);
writeVideo(video,T)
close(video)

