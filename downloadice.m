clear variables;close all;
im_path='C:\Users\Angel\Desktop\ice_im\';
site='osisaf.met.no';
indir='archive/ice/conc/';

f = ftp(site);
cd(f); sf=struct(f); sf.jobject.enterLocalPassiveMode();
cd(f,indir)

st=[386   518     1];
ct=[264   316     1];

count=0;
yrs=dir(f);
ice=nan(ct(1),ct(2),numel(yrs),366);
ice_uf=ice;
ice_cl=ice;

for i=1:numel(yrs)
    i
    mth=dir(f,yrs(i).name);
    cd(f,yrs(i).name);
    doy=0;
    for j=1:numel(mth)
        cd(f,mth(j).name);
        dy=dir(f,'*_nh_polstere*.nc');
        indir2=[yrs(i).name '/' mth(j).name '/'];
        for k=1:numel(dy)
            count=count+1;
            disp(['downloading image ' num2str(count)]);
            tic
            doy=doy+1;
            DOY(count)=doy;
            fn=dy(k).name;
            mget(f,fn,im_path);
            disp(['processing image ' num2str(count)]);
            if count==1
               lat=ncread([im_path fn],'lat',st(1:2),ct(1:2));
               lon=ncread([im_path fn],'lon',st(1:2),ct(1:2));
            end
            ice(:,:,i,doy)=ncread([im_path fn],'ice_conc',st,ct);
            ice_uf(:,:,i,doy)=ncread([im_path fn],'ice_conc_unfiltered',st,ct);
            ice_cl(:,:,i,doy)=ncread([im_path fn],'ice_conc_unfiltered',st,ct);
            delete([im_path fn])
            toc
        end
        cd(f,'..');
    end
    cd(f,'..');
end


% %%
% filename='ice_conc_nh_polstere-100_multi_201512011200.nc';
% info=ncinfo([indir filename]);
% lat=ncread([indir filename],'lat');
% lon=ncread([indir filename],'lon');
% 
% % european arctic
% lonlims=[-25 60];  
% latlims=[66 90];
% [lon_pts,lat_pts]=corners(lonlims,latlims);
% in=inpolygon(lon,lat,lon_pts,lat_pts);
% [in1,in2]=ind2sub(size(lon),find(in==1));
% in1_lim=[min(in1) max(in1)];
% in2_lim=[min(in2) max(in2)];
% 
% st1=in1_lim(1);n1=diff(in1_lim)+1;
% st2=in2_lim(1);n2=diff(in2_lim)+1; 
% 
% %st=[st1 st2 1];
% %ct=[n1 n2 1];
% st=[386   518     1];
% ct=[264   316     1];
% 
% 

% 
% %% 
% ftpobj = ftp(site);
% dir(ftpobj)
% cd(ftpobj,indir)
% mget(ftpobj,'ice_conc_nh_polstere-100_multi_200503011200.nc');
% 
% 
% 
% % for i=1:
% % ice(:,:,i)=ncread([indir filename],'ice_conc',st,ct);
