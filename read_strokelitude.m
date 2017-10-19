cd('C:\Users\Students\Desktop');
h5disp('strokelitude20160419_062748.h5')
hinfo = hdf5info('strokelitude20160419_062748.h5')
level2 = hinfo.GroupHierarchy(1)
dataset1 = level2.Datasets(1)
dataset2 = level2.Datasets(2)
data = h5read('strokelitude20160419_062748.h5','/stroke_data')