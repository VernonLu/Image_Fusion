%%%????--color transfer
function swgc=swatchcolortransfer(swg,swc,hwin,sizejit)
    %swg--??????
    %swc--??????
    %hwin--???????
    %sizejit--???????????????????50?100?200??
    swg=double(swg);
    swc=double(swc);
    sizewin=2*hwin+1;
    
    %??????  RGB  to lab
    labsw=rgblab(swc,0);
    %??????
    ms=zeros(3,2);
    ms(1,1)=mean2(labsw(:,:,1));
    ms(1,2)=std2(labsw(:,:,1));
    ms(2,1)=mean2(labsw(:,:,2));
    ms(2,2)=std2(labsw(:,:,2));
    ms(3,1)=mean2(labsw(:,:,3));
    ms(3,2)=std2(labsw(:,:,3));
    
    %??
    uc=mean2(labsw(:,:,1));
    dc=std2(labsw(:,:,1));
    ug=mean2(swg(:,:,1));
    dg=std2(swg(:,:,1));
    if dg~=0
       labsw(:,:,1)=(labsw(:,:,1)-uc).*(dg/dc)+ug; 
    end
    
    %???????????
    ucv0=colfilt(labsw(:,:,1),[sizewin,sizewin],'sliding',@mean);
    dcv0=colfilt(labsw(:,:,1),[sizewin,sizewin],'sliding',@std);
    ugv0=colfilt(swg(:,:,1),[sizewin,sizewin],'sliding',@mean);
    dgv0=colfilt(swg(:,:,1),[sizewin,sizewin],'sliding',@std);
    
    [mc nc]=size(labsw(:,:,1));
    [mg ng]=size(swg(:,:,1));
    ucv=ucv0(1+hwin:mc-hwin,1+hwin:nc-hwin);
    dcv=dcv0(1+hwin:mc-hwin,1+hwin:nc-hwin);
    ugv=ugv0(1+hwin:mg-hwin,1+hwin:ng-hwin);
    dgv=dgv0(1+hwin:mg-hwin,1+hwin:ng-hwin);
    sw_u=ugv;
    sw_d=dgv;
    
    labsw=labsw(1+hwin:mc-hwin,1+hwin:nc-hwin,:);
    swg=swg(1+hwin:mg-hwin,1+hwin:ng-hwin,:);
    
    mc=mc-2*hwin;
    nc=nc-2*hwin;
    mg=mg-2*hwin;
    ng=ng-2*hwin;
    
    %?????????
    seljitt=zeros(sizejit,5);
    for i=1:sizejit
       ra1=uint16(rand(1)*(mc-1)+1);
       ra2=uint16(rand(1)*(nc-1)+1);
       seljitt(i,1:3)=labsw(ra1,ra2,1:3);
       seljitt(i,4)=ucv(ra1,ra2);
       seljitt(i,5)=dcv(ra1,ra2);
    end
    
    %???????
    for ii=1:mg
        for jj=1:ng
            minv=100000;
            for i=1:sizejit
                LS=abs(seljitt(i,4)-ugv(ii,jj))+abs(seljitt(i,5)-dgv(ii,jj));
                if LS<minv
                    minv=LS;
                    iii=i;
                end
            end
            swg(ii,jj,2:3)=seljitt(iii,2:3);
        end
    end
    
    %?????? lab to RGB
    swgc=rgblab(swg(1:mg,1:ng,:),1);
    %return swgc;
    imshow(swgc);
    
    
    