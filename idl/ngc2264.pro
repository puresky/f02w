distance = 760 ; pc

Tmb_12CO_rms = 0.440401  ; K
Tmb_13CO_rms = 0.237389
Tmb_C18O_rms = 0.242055

print, '3 Tmb_12CO_rms = ', 3*Tmb_12CO_rms
print, '3 Tmb_13CO_rms = ', 3*Tmb_13CO_rms
print, '3 Tmb_C18O_rms = ', 3*Tmb_C18O_rms


;
;tpeak,"ngc226412cofinal.fits", outfile="tpeak_12CO.fits",v_range = [-35,75], velocity_file='Vpeak_12CO.fits'
;tpeak,"ngc226413cofinal.fits", outfile="tpeak_13CO.fits",v_range = [-20,60], velocity_file='Vpeak_13CO.fits'
;tpeak,"ngc2264c18ofinal.fits", outfile="tpeak_C18O.fits",v_range = [-10,20], velocity_file='Vpeak_C18O.fits'

;print, 'Tpeak 12CO map'
;    fits_read, 'tpeak.fits', data, hdr
;    pson
;        device, filename='Tpeak_12CO.eps',/encapsulated
;        device,/portrait
;            cgimage,data,/keep_aspect, position = pos
;        device, /close_file
;    psoff

;print,"Tpeak 12CO Histogram"
;    fits_read,"tpeak.fits",data,hdr
;    validdata=data[where(data lt 42.7905, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3 * Tmb_12CO_rms
;    print,'above noise: ', size(where(validdata gt noiselevel))
;
;    pson & !P.multi = [0,1,2] & !Y.OMARGIN=[1,0]
;        device,filename='tpeak_his.eps',/encapsulated
;        device,xsize=21.0,ysize=29.7,/portrait
;        binsize=1.0
;        plothist,validdata,xhist,yhist,bin=binsize,/noplot
;        yhist = yhist/120000d/binsize
;        peak = max(yhist,max_subscript)
;;        yfit = gaussfit(alog(xhist[0:18]),yhist[0:18]*xhist[0:18],coeff,chisq=chisquare,nterms=3)/xhist[0:18]
;        yfit = gaussfit(alog(xhist),yhist*xhist,coeff,chisq=chisquare,nterms=3)/xhist
;        print, 'peak =', peak, '   peak_subscript =', max_subscript
;        print, 'A, mu, sigma:', coeff & print, 'chi square=',chisquare
;        !P.multi[0] = 2
;        !X.margin=[8,8] &  !Y.margin=[4,4] 
;;        position=[0.125,0.125,0.85,0.9]
;        cgPlot, xhist,yhist,/nodata,xstyle=1,ystyle=8$
;              , charsize=1.4,title='T!Ipeak !N!E12!NCO PDF of NGC 2264',xtitle='T!Ipeak !N(K)',ytitle='P(s)' $
;              , /ylog,xrange=[-5,50],yrange=[1e-5,1]
;        cgColorFill, [-5,-5,noiselevel,noiselevel],[1e-5,1,1,1e-5], color='grey'
;        plothist, validdata, bin=binsize, peak=peak, charsize=1.4,charthick=2,xthick=2,ythick=2 $
;                ,/overplot
;        cgOplot,xhist,yfit,color='green'
;        cgAxis,xaxis=0,xstyle=1,charsize=1.4, xrange=[-5,50]
;        cgAxis,xaxis=1,xstyle=1,charsize=0.01
;        cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=[1e-5,1]
;        cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=[1e-5,1]*120000d*binsize, ytitle=textoidl('Number of Pixels per bin')
;        cgplots,[1,1]*noiselevel, [1e-5,1],linestyle=2
;;        cgtext,noiselevel,2e5,'W!ICO!N(3 sigma)',charsize=1
;;        cgText, 40, 1e-1, 'N = 120000', color='navy', charsize=1.5
;;        cgText, 40, 3e-2, cggreek('sigma')+' ='+string(noiselevel/3.0,Format='(F10.2)'), color='navy', charsize=1.5
;;        bins=[-1,-0.1,-0.01,0.0,0.01,0.1,1.0,10.0,100.0]
;;        logvaliddata = Value_Locate(bins,validdata)
;        logvaliddata=alog(validdata)
;        binsize=0.1 &         xrange =[-1,4.5] & yrange =[1e-4,3]
;        plothist,logvaliddata,xhist,yhist,bin=binsize,/noplot
;        yhist= yhist/120000d/binsize
;        peak = max(yhist,max_subscript)
;        yfit = GaussFit(xhist[0:16], yhist[0:16], coeff, NTERMS=3, chisq=chisquare)
;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;       ; !x.margin=[8,8] & !y.margin=[4,4]
;        cgPlot, xhist, yhist, /nodata, xstyle=9, ystyle=9 $
;              , charsize=1.4, xtitle='ln(T!Ipeak!N/[K])',ytitle='P(s)' $
;              , /ylog,xrange=xrange,yrange=yrange
;        cgColorFill, [xrange[0],xrange[0],alog(noiselevel),alog(noiselevel)],[yrange,reverse(yrange)], color='grey'
;        plothist, logvaliddata, bin=binsize, peak=peak, charsize=1.4,charthick=2,xthick=2,ythick=2 $
;                , /overplot, ystyle=1,yrange=yrange
;        cgOplot, xhist, yfit,color='green'
;        cgplots,[1,1]*alog(noiselevel),yrange,linestyle=2
;        cgAxis,xaxis=0,xstyle=1,charsize=1.4
;        cgAxis,xaxis=1,xstyle=1,charsize=1.4,xrange=exp(xrange),xlog=1, xtitle=textoidl('T_{peak} (K)')
;        cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=yrange
;        cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=yrange*120000d*binsize, ytitle=textoidl('Number of Pixels per bin')
;;        cgtext,noiselevel,2e5,'3 sigma',charsize=1
;        device,/close_file
;    psoff & !P.multi=0 & !Y.OMARGIN=[0,0]

print,'Velocity of Tpeak 12CO Histogram'
    fits_read,'tpeak.fits',Tpeak,TpHdr
    fits_read,'Vpeak_12CO.fits',Vpeak,VpHdr
    Vpeak_valid=Vpeak[where(Tpeak gt 3*Tmb_12CO_rms and Tpeak lt 42.7905)]
    help,Vpeak_valid
    image_statistics, Vpeak_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
    fits_read,'Vcenter_12CO.fits',Vgauss,VgHdr
    fits_read,'Tfwhm_12CO.fits',FWHM,FwhmHdr
    Vgauss_valid=Vgauss[where(Vgauss gt -35 and Vgauss lt 75 and FWHM gt 0.158 and FWHM lt 110 and Tpeak lt 42.7905)]
    help,Vgauss_valid
    image_statistics, Vgauss_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
    fits_read,'ngc226412cofinal_m1.fits',Vmoment,VmHdr
    Vmoment_valid=Vmoment[where(Vmoment gt -35 and Vmoment lt 75 and Tpeak lt 42.7905)]
    help,Vmoment_valid
    image_statistics, Vmoment_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
print,'Line Width 12CO Histogram'
    fits_read,'tpeak.fits',Tpeak,TpHdr
    fits_read,'Tfwhm_12CO.fits',FWHM,FwhmHdr
    FWHM_valid=FWHM[where(Vgauss gt -35 and Vgauss lt 75 and FWHM gt 0.158 and FWHM lt 110 and Tpeak lt 42.7905)]
    help,FWHM_valid
    image_statistics, FWHM_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
    fits_read,'ngc226412cofinal_m2.fits',Vmoment,VmHdr
    Vmoment_valid=Vmoment[where(Tpeak gt 3*Tmb_12CO_rms and Tpeak lt 42.7905)]
    help,Vmoment_valid
    image_statistics, Vmoment_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
 
    pson & !P.multi = [0,1,2] & !Y.OMARGIN=[1,0]
        device,filename='velocity_his.eps',/encapsulated
        device,xsize=21.0,ysize=29.7,/portrait
        binsize=1.0 & xrange=[-45,85] & yrange=[1e-5,1]
        plothist,Vpeak_valid,xhist,yhist,bin=binsize,/noplot
        Nsamples=n_elements(Vpeak_valid)/1.0
        yhist = yhist/Nsamples/binsize
        peak = max(yhist,max_subscript)
;        yfit = gaussfit(alog(xhist),yhist*xhist,coeff,chisq=chisquare,nterms=3)/xhist
        print, 'peak =', peak, '   peak_subscript =', max_subscript 
        print, 'A, mu, sigma:', coeff & print, 'A*sqrt(2*!pi)*sigma =', coeff[0]*sqrt(2*!pi)*coeff[2] & print, 'chi square=',chisquare
        !P.multi[0] = 2
        !X.margin=[8,8] &  !Y.margin=[4,4] 
        cgPlot, xhist,yhist,/nodata,xstyle=1,ystyle=8$
              , charsize=1.4,title='V !E12!NCO PDF of NGC 2264',xtitle='V (km/s)',ytitle='P(s)' $
              , /ylog,xrange=xrange,yrange=yrange
;        cgColorFill, [-5,-5,noiselevel,noiselevel],[yrange,reverse(yrange)], color='grey'
        plothist, Vpeak_valid, bin=binsize, peak=peak, charsize=1.4,charthick=2,xthick=2,ythick=2 $
                , color='green', /overplot
        plothist, Vgauss_valid, bin=binsize, xhist,yhist,/noplot
        peak=max(yhist)/n_elements(Vgauss_valid)/binsize
        plothist, Vgauss_valid, bin=binsize,peak=peak, color='ivory',/overplot
        plothist, Vmoment_valid,bin=binsize, xhist,yhist,/noplot
        peak=max(yhist)/n_elements(Vmoment_valid)/binsize
        plothist, Vmoment_valid,bin=binsize,peak=peak, color='blue',/overplot
;        cgOplot,xhist,yfit,color='green'
        cgLegend, Title=['Peak','Gauss Fit', 'Moment 1'] $
                , PSym=[-15,-15,-15], SymSize=1, Alignment=1 $
                , color=['green','ivory','blue']
        cgAxis,xaxis=0,xstyle=1,charsize=1.4, xrange=xrange
        cgAxis,xaxis=1,xstyle=1,charsize=0.01
        cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=yrange
        cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;        cgplots,[1,1]*noiselevel, [1e-5,1],linestyle=2
;        cgtext,noiselevel,2e5,'W!ICO!N(3 sigma)',charsize=1
;        cgText, 40, 1e-1, 'N = 120000', color='navy', charsize=1.5
;        cgText, 40, 3e-2, cggreek('sigma')+' ='+string(noiselevel/3.0,Format='(F10.2)'), color='navy', charsize=1.5
        logvaliddata=alog(validdata)
        binsize=0.04 &         xrange =[-0.4,1.8] & yrange =[1e-4,10]
        plothist,logvaliddata,xhist,yhist,bin=binsize,/noplot
        yhist= yhist/n_elements(logvaliddata)/binsize
        peak = max(yhist,max_subscript)
        yfit = GaussFit(xhist[0:18], yhist[0:18], coeff, NTERMS=3, chisq=chisquare)
        print, 'peak =', peak, '    peak_subscript =', max_subscript
        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
       ; !x.margin=[8,8] & !y.margin=[4,4]
        cgPlot, xhist, yhist, /nodata, xstyle=1, ystyle=8 $
              , charsize=1.4, title=textoidl('\Delta V ^{12}CO PDF of NGC 2264'),xtitle='Log(V/[km/s])',ytitle='P(s)' $
              , /ylog,xrange=xrange,yrange=yrange
        cgColorFill, [xrange[0],xrange[0],alog10(noiselevel),alog10(noiselevel)],[yrange,reverse(yrange)], color='grey'
        plothist, logvaliddata, bin=binsize, peak=peak, charsize=1.4,charthick=2,xthick=2,ythick=2 $
                , /overplot
        cgOplot, xhist, yfit,color='green'
        cgplots,[1,1]*alog10(noiselevel),yrange,linestyle=2
        cgAxis,xaxis=0,xstyle=1,charsize=1.4
        cgAxis,xaxis=1,xstyle=1,charsize=0.01
        cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=yrange
        cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=yrange*120000d*binsize, ytitle=textoidl('Number of Pixels per log bin')
;        cgtext,noiselevel,2e5,'3 sigma',charsize=1
        device,/close_file
    psoff & !P.multi=0 & !Y.OMARGIN=[0,0]

        cgLegend, Title=['Gauss Fit', 'Moment 2'] $
                , PSym=[-15,-16], SymSize=1, Color=['red','dodger blue'], /Center_Sym, LineStyle=[0,2]
                , VSpace=2.0, /Box, Alignment=4, Location=[40,1e5], /Data 
;
;print,"Tpeak 13CO Histogram"
;    fits_read,"tpeak_13CO.fits",data,hdr
;    validdata=data[where(data lt 16.74136, count)]
    ;print,count
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'above noise: ', size(where(validdata gt 3*0.24))
;    pson
;        device,filename='tpeak_13CO_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;        	,title='T!Ipeak !N!E13!NCO PDF',xtitle='T!Ipeak !N(K)',ytitle='Number'$
;        	,/ylog,xrange=[-5,20],yrange=[0.1,1e6]
;        cgplots,[0.93,0.93],[0.5,1e5],linestyle=2
;        cgtext,0.9,2e5,'3 sigma',charsize=1
;        device,/close_file
;    psoff
;;
;;
;print,"Tpeak C18O Histogram"
;    fits_read,"tpeak_C18O.fits",data,hdr
;    validdata=data[where(data lt 10.1618, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'above noise: ', size(where(validdata gt 3*0.24))
;    pson
;        device,filename='tpeak_C18O_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;        	,title='T!Ipeak!N C!E18!NO PDF',xtitle='T!Ipeak !N(K)',ytitle='Number'$
;        	,/ylog,xrange=[-1,8],yrange=[0.1,1e6]
;        cgplots,[0.72,0.72],[0.5,1e5],linestyle=2
;        cgtext,0.9,2e5,'3 sigma',charsize=1
;        device,/close_file
;    psoff
;
;
;
;
;print,'12CO rms Histogram'
;    rdfloat,'ngc226412cofinal.bas_rms.dat',line12CO,ra12CO,dec12CO,rms12CO
;    print,max(rms12CO),min(rms12CO),mean(rms12CO)
;    print,mean(rms12CO(where(ra12CO gt -1000 and ra12CO lt 1000 and dec12CO gt -1000 and dec12CO lt 6000))) 
;    pson
;        device,filename='rms_12CO_his.eps',/encapsulated
;        device,/portrait
;        plothist,rms12CO,bin=0.02,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='!E12!NCO rms PDF',xtitle='T!Irms !N(K)',ytitle='Number'$
;               ,/ylog,xrange=[0,3],yrange=[0.5,2e5]
;        cgplots,[0.44,0.44],[0.5,2e4],linestyle=2
;        cgtext,0.440401,3e4,'0.46',charsize=1
;        cgplots,[0.72,0.72],[0.5,2e4],linestyle=2
;        cgtext,0.720845,3e4,'0.72',charsize=1
;        device,/close_file
;    psoff
;
;
;print, '13CO rms Histogram'
;    rdfloat,'ngc226413cofinal.bas_rms.dat',line13CO,ra13CO,dec13CO,rms13CO
;    print,max(rms13CO),min(rms13CO),mean(rms13CO)
;    print,mean(rms13CO(where(ra13CO gt -1000 and ra13CO lt 1000 and dec13CO gt -1000 and dec13CO lt 6000)))
;    pson
;        device,filename='rms_13CO_his.eps',/encapsulated
;        device,/portrait
;        plothist,rms13CO,bin=0.02,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='!E13!NCO rms PDF',xtitle='T!Irms !N(K)',ytitle='Number'$
;               ,/ylog,xrange=[0,3],yrange=[0.5,2e5]
;        cgplots,[0.24,0.24],[0.5,2e4],linestyle=2
;        cgtext,0.237389,3e4,'0.24',charsize=1
;        cgplots,[0.46,0.46],[0.5,2e4],linestyle=2
;        cgtext,0.457899,3e4,'0.46',charsize=1
;        device,/close_file
;    psoff
;
;print, 'C18O rms Histogram'
;    rdfloat,'ngc2264c18ofinal.bas_rms.dat',line_C18O,ra_C18O,dec_C18O,rms_C18O
;    print,max(rms_C18O),min(rms_C18O),mean(rms_C18O)
;    print,mean(rms_C18O(where(ra_C18O gt -1000 and ra_C18O lt 1000 and dec_C18O gt -1000 and dec_C18O lt 6000)))
;    pson
;        device,filename='rms_C18O_his.eps',/encapsulated
;        device,/portrait
;        plothist,rms_C18O,bin=0.02,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='C!E18!NO rms PDF',xtitle='T!Irms !N(K)',ytitle='Number'$
;               ,/ylog,xrange=[0,3],yrange=[0.5,2e5]
;        cgplots,[0.24,0.24],[0.5,2e4],linestyle=2
;        cgtext,0.242055,3e4,'0.24',charsize=1
;        cgplots,[0.46,0.46],[0.5,2e4],linestyle=2
;        cgtext,0.459661,3e4,'0.46',charsize=1
;        device,/close_file
;    psoff


;tex,infile="Tpeak.fits",outfile="Tex.fits"
;

;print,"Tex Histogram: Tex_his.eps"
;    fits_read,"Tex.fits",data,hdr
;    validdata=data[where(data lt 46.3205, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    T0 = 5.53213817d   ;12CO(1-0) 
;    Tex_3rms = T0*(alog(1+T0/(Tmb_12CO_3rms+0.819)))^(-1)
;    print, 'noise line derived from Tpeak: Tex(3rms) = ',Tex_3rms
;    print, 'above noise: ', size(where(validdata gt Tex_3rms)) ; 4.4002
;    pson
;        device,filename='Tex_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,xhist,yhist,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='Tex PDF of NGC 2264',xtitle='T!Iex !N(K)',ytitle='Number' $
;               ,/ylog,xrange=[0,50],yrange=[0.5,1e6]
;        cgplots,[1,1]*Tex_3rms,[0.6,1e5],linestyle=2
;        cgtext,Tex_3rms,2e5,'T!Iex!N (3 !7r!3) = 0.44 K',charsize=1
;        yhistfit=gaussfit(xhist,yhist,coeff,nterms=3)
;        print,coeff
;        cgoplot,xhist,yhistfit,linestyle=1,color='green'
;        yhistfit=gaussfit(xhist,yhist-yhistfit,coeff,nterm=3)
;        print,coeff
;        cgoplot,xhist,yhistfit,linestyle=1,color='blue'
;        device,/close_file
;    psoff

;cubemoment, 'ngc226412cofinal.fits', [-10,40]
;cubemoment, 'ngc226413cofinal.fits', [-10,35]
;cubemoment, 'ngc2264c18ofinal.fits', [1,12]

;file_move,'ngc226412cofinal_m0.fits','Wco_12CO.fits'

;print,"Integrated Intensities Histogram: Int_12CO_his.eps"
;    fits_read,'12co_-10_40_int.fits',data,hdr
;    validdata=data[where(data lt 2146, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = Tmb_12CO_3rms*sqrt(50*0.159)
;    print, 'noise level: 3 sigma,', noiselevel 
;    print, 'above noise: ', size(where(validdata gt noiselevel))
;    pson
;        device,filename='Int_12CO_-10_40_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='!E12!NCO Integrated Intensities PDF of NGC 2264',xtitle='Integrated Intensities (K km s!E-1!N)',ytitle='Number' $
;               ,/ylog,xrange=[-35,245],yrange=[0.5,1e6]
;        cgplots,[1,1]*noiselevel,[0.1,1e5],linestyle=2
;        cgtext,noiselevel,2e5,'W!ICO!N(3 sigma)',charsize=1
;        device,/close_file
;    psoff
;
;print,"Integrated Intensities Histogram: Int_13CO_his.eps"
;    fits_read,'13co_-10_35_int.fits',data,hdr
;    validdata=data[where(data lt 756, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3*Tmb_13CO_rms*sqrt(45*0.167)
;    print, 'noise level: 3 sigma,', noiselevel
;    print, 'above noise: ', size(where(validdata gt noiselevel))
;    pson & !P.multi = [0,1,2]
;        device,filename='Int_13CO_-10_35_his.eps',/encapsulated
;        device,xsize=21.0,ysize=29.7,/portrait
;        binsize=0.5
;        plothist,validdata,xhist,yhist,bin=binsize,/noplot
;        cgColorFill, Position=[0.125, 0.125, noiselevel, 0.9], Color='ivory'
;        peak = max(yhist)/120000d/bin
;        yhist = yhist/120000d/bin
;        yfit = exp(gaussfit(xhist,alog(yhist),coeff,chisq=chisquare))
;        help, peak, coeff, chisquare
;
;        plothist,validdata, bin=binsize,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='!E13!NCO Integrated Intensities PDF of NGC 2264',xtitle='Integrated Intensities (K km s!E-1!N)',ytitle='Number' $
;               ,/ylog,xrange=[-25,65],yrange=[0.5,1e6]
;        yfit = GaussFit(xhist, yhist, coeff, NTERMS=3)
;        cgplots,[1,1]*noiselevel, [0.1,1e5],linestyle=2
;        cgtext,noiselevel,2e5,'W!ICO!N(3 sigma)',charsize=1
;        cgLegend, Title=['N!Isamples!N=120000', cggreek('sigma')+'='+string(noiselevel/3.0)], PSym=[-15,-16], $
;                  SymSize=1, Color=['red','dodger blue'], Location=[50,1e5], /Data, $
;                  /Center_Sym, LineStyle=[0,2], VSpace=2.0, /Box, Alignment=4
;        logvaliddata = alog(validdata)
;        plothist,logvaliddata,bin=0.1,min=-15,max=10,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='!E13!NCO Integrated Intensities PDF of NGC 2264',xtitle='Log([Integrated Intensities]/[K km s!E-1!N])',ytitle='Number' $
;               ,/ylog,xrange=[-15,6],yrange=[0.5,1e6]
;
;        device,/close_file
;    psoff & !P.multi = 0
;
;print,"Integrated Intensities Histogram: Int_C18O_his.eps"
;    fits_read,'c18o_1_12_int.fits',data,hdr
;    validdata=data[where(data lt 113, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = Tmb_C18O_3rms*sqrt(11*0.167)
;    print, 'noise level: 3 sigma,', noiselevel
;    print, 'above noise: ', size(where(validdata gt noiselevel))
;    pson
;        device,filename='Int_C18O_1_12_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='C!E18!NO Integrated Intensities PDF of NGC 2264',xtitle='Integrated Intensities (K km s!E-1!N)',ytitle='Number' $
;               ,/ylog,xrange=[-10,15],yrange=[0.5,1e6]
;        cgplots,[1,1]*noiselevel, [0.1,1e5],linestyle=2
;        cgtext,noiselevel, 2e5,'W!ICO!N(3 sigma)',charsize=1
;        device,/close_file
;    psoff


;fwhm, 'ngc226412cofinal.fits', outfile='fwhm_12CO.fits', v_center_file = 'Vcenter_12CO.fits', v_range = [-35,75],quality_file='Quality_fwhm_12CO.fits';, estimates=[1,5,1,0,0,0]
;fwhm, 'ngc226413cofinal.fits', outfile='fwhm_13CO.fits', v_center_file = 'Vcenter_13CO.fits', v_range = [-20,60]
;fwhm, 'ngc2264c18ofinal.fits', outfile='fwhm_C18O.fits', v_center_file = 'Vcenter_C18O.fits', v_range = [-10,20]

;print, 'FWHM Histogram: 12CO'
;    fits_read,"Tfwhm_12CO.fits",data,hdr
;    print,max(data),min(data),mean(data)
;;    validdata=data[where(data lt 46.3205 and data gt -40, count)]
;    fits_read,'Vcenter_12CO.fits',vdata,vhdr
;    validdata=data[where(vdata gt -30 and vdata lt 75)]
;    help,validdata;,data,data[where(data lt 46 and data gt -40)]
;    print,max(validdata),min(validdata),mean(validdata)
;;    print, 'above noise: ', size(where(validdata gt Tex_3rms)) ; 4.4002
;    pson
;        device,filename='Tfwhm_12CO_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,xhist,yhist,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='!E12!NCO Line Width PDF of NGC 2264',xtitle=textoidl('\Delta V')+' (km s!E-1!N)',ytitle='Number'$
;               ,/ylog,xrange=[-7,15],yrange=[0.5e2,1e6]
;;        cgplots,[1,1]*Tex_3rms,[0.1,1e5],linestyle=2
;;        cgtext,Tex_3rms,2e5,'Tex(3 sigma)',charsize=1
;;        oplot,xhist,yhist,linestyle=1
;        device,/close_file
;    psoff
;print, 'Vcenter Histogram: 12CO'
;    validdata=vdata[where(vdata gt -30 and vdata lt 70)]
;    print,max(vdata),min(vdata),mean(vdata)
;    print,max(validdata),min(validdata),mean(validdata)
;    help,validdata
;    pson
;        device,filename='Vcenter_12CO_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='!E12!NCO V PDF of NGC 2264', xtitle='V (km s!E-1!N)', ytitle='Number' $
;               ,/ylog,xrange=[-35,75],yrange=[0.5e2,0.5e5]
;        device,/close_file
;    psoff
;
;
;print, 'FWHM Histogram: 13CO'
;    fits_read,"Tfwhm_13CO.fits",data,hdr
;    print,max(data),min(data),mean(data)
;;    validdata=data[where(data lt 46.3205 and data gt -40, count)]
;    fits_read,'Vcenter_13CO.fits',vdata,vhdr
;    validdata=data[where(vdata gt -30 and vdata lt 75)]
;    help,validdata;,data,data[where(data lt 46 and data gt -40)]
;    print,max(validdata),min(validdata),mean(validdata)
;    pson
;        device,filename='Tfwhm_13CO_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,xhist,yhist,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='!E13!NCO Line Width PDF of NGC 2264',xtitle=textoidl('\Delta V')+' (km s!E-1!N)',ytitle='Number'$
;               ,/ylog,xrange=[-7,15],yrange=[0.5,1e6]
;;        cgplots,[1,1]*Tex_3rms,[0.1,1e5],linestyle=2
;;        cgtext,Tex_3rms,2e5,'Tex(3 sigma)',charsize=1
;;        oplot,xhist,yhist,linestyle=1
;        device,/close_file
;    psoff
;print, 'Vcenter Histogram: 13CO'
;    validdata=vdata[where(vdata gt -30 and vdata lt 70)]
;    print,max(vdata),min(vdata),mean(vdata)
;    print,max(validdata),min(validdata),mean(validdata)
;    help,validdata
;    pson
;        device,filename='Vcenter_13CO_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='!E13!NCO V PDF of NGC 2264', xtitle='V (km s!E-1!N)', ytitle='Number' $
;               ,/ylog,xrange=[-25,65],yrange=[0.5e2,0.5e5]
;        device,/close_file
;    psoff
;
;
;print, 'FWHM Histogram: C18O'
;    fits_read,"Tfwhm_C18O.fits",data,hdr
;    print,max(data),min(data),mean(data)
;;    validdata=data[where(data lt 46.3205 and data gt -40, count)]
;    fits_read,'Vcenter_C18O.fits',vdata,vhdr
;    validdata=data[where(vdata gt -30 and vdata lt 75)]
;    help,validdata;,data,data[where(data lt 46 and data gt -40)]
;    print,max(validdata),min(validdata),mean(validdata)
;    pson
;        device,filename='Tfwhm_C18O_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,xhist,yhist,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='C!E18!NO Line Width PDF of NGC 2264',xtitle=textoidl('\Delta V')+' (km s!E-1!N)',ytitle='Number'$
;               ,/ylog,xrange=[-7,15],yrange=[0.5,1e6]
;;        cgplots,[1,1]*Tex_3rms,[0.1,1e5],linestyle=2
;;        cgtext,Tex_3rms,2e5,'Tex(3 sigma)',charsize=1
;;        oplot,xhist,yhist,linestyle=1
;        device,/close_file
;    psoff
;print, 'Vcenter Histogram: C18O'
;    validdata=vdata[where(vdata gt -30 and vdata lt 70)]
;    print,max(vdata),min(vdata),mean(vdata)
;    print,max(validdata),min(validdata),mean(validdata)
;    help,validdata
;    pson
;        device,filename='Vcenter_C18O_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='C!E18!NO V PDF of NGC 2264', xtitle='V (km s!E-1!N)', ytitle='Number' $
;               ,/ylog,xrange=[-15,35],yrange=[0.5e2,0.5e5]
;        device,/close_file
;    psoff

;tau,'tpeak_13CO.fits',tex_file='Tex.fits',outfile='tau_13CO.fits'
;tau,'tpeak_C18O.fits',tex_file='Tex.fits',outfile='tau_C18O.fits'
;tau,
;print,"tau 13CO Histogram"
;    fits_read,"tau_13CO.fits",data,hdr
;    validdata=data[where(tex lt 46.3205, count)]
;    validdata=validdata[where(finite(validdata))]
;   ;print,count
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'above noise: ', size(where(validdata gt 3*0.24))
;    pson
;        device,filename='tau_13CO_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=0.2,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='!7s!X!N C!E13!NO PDF',xtitle='!7s!X',ytitle='Number'$
;               ,/ylog,xrange=[-1,12],yrange=[0.1,1e6]
;;        cgplots,[0.93,0.93],[0.5,1e5],linestyle=2
;;        cgtext,0.9,2e5,'3 sigma',charsize=1
;        device,/close_file
;    psoff
;
;
;print,"tau C18O Histogram"
;    fits_read,"tau_C18O.fits",data,hdr
;    validdata=data[where(tex lt 46.3205, count)]
;    validdata=validdata[where(finite(validdata))]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'above noise: ', size(where(validdata gt 3*0.24))
;    pson
;        device,filename='tau_C18O_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=0.2,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='!7s!X C!E18!NO PDF',xtitle='!7s!X',ytitle='Number'$
;               ,/ylog,xrange=[-1,12],yrange=[0.1,1e6]
;;        cgplots,[0.72,0.72],[0.5,1e5],linestyle=2
;;        cgtext,0.9,2e5,'3 sigma',charsize=1
;        device,/close_file
;    psoff


;n_co, "13CO", 'Wco', "Wco_13CO_-10_35.fits", outfile='Nco_Wco_13CO.fits'
;n_co, "C18O", 'Wco', "Wco_C18O_1_12.fits",   outfile='Nco_Wco_C18O.fits'
;n_co,'13CO', 'Tpeak', 'tpeak_13CO.fits', tex_file="Tex.fits", fwhm_file='fwhm_13CO.fits', outfile='Nco_Tpeak_13CO.fits'
;n_co,'C18O', 'Tpeak', 'tpeak_C18O.fits', tex_file="Tex.fits", fwhm_file='fwhm_C18O.fits', outfile='Nco_Tpeak_C18O.fits'
;n_co, '13CO', 'tau', 'tau_13CO.fits', tex_file="Tex.fits", fwhm_file='fwhm_13CO.fits', outfile='Nco_tau_13CO.fits'
;n_co, 'C18O', 'tau', 'tau_C18O.fits', tex_file="Tex.fits", fwhm_file='fwhm_C18O.fits', outfile='Nco_tau_C18O.fits'
;print,"Nco Histogram: Nco_13CO_his.eps"
;    fits_read,"Nco_13co_-10_35_int.fits",data,hdr
;    validdata=data[where(data lt 1.6956942e+18, count)]
;    help,validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    pson
;        device,filename='Nco_13CO_his.eps',/encapsulated
;        device,/portrait
;        bin = 1e15
;        plothist, validdata, xhist, yhist, bin=bin, /noplot
;        peak = max(yhist)/120000d/bin
;        yhist = yhist/120000d/bin
;        yfit = exp(gaussfit(xhist,alog(yhist),coeff,chisq=chisquare))
;        help, peak, coeff, chisquare
;        plothist,validdata,bin=bin, peak=peak, /boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;                ,title='N(!E13!NCO) PDF of NGC 2264',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;                ,/ylog,xrange=[-1e16,1.3e17],yrange=[1e-20,1e-15]
;        cgplot, xhist,yfit, psym=1, /overplot
;        cgLegend, Title=['N!Isample!N = 120000', '\$sigma$ = '], PSym=[-15,-16], $
;                  SymSize=2, Color=['red','dodger blue'], Location=[50,130], /Data, $
;                  /Center_Sym, LineStyle=[0,2], VSpace=2.0, /Box, Alignment=4
;        device,/close_file
;    psoff

;print,"Nco Histogram: Nco_C18O_his.eps"
;    fits_read,"Nco_c18o_1_12_int.fits",data,hdr
;    validdata=data[where(data lt 2.3637384e+17, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    pson
;        device,filename='Nco_C18O_his.eps',/encapsulated
;        device,/portrait
;        bin= 1e15
;         peak = max(histogram(validdata, binsize=bin))/120000d
;        print, peak
;        plothist,validdata,bin=bin, peak = peak, /boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(C!E18!NO) PDF of NGC 2264',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-1e16,2e16],yrange=[1e-5,1]
;        device,/close_file
;    psoff

;print,"Nco Histogram: Nco_13CO_Tpeak_his.eps"
;    fits_read,"Nco_Tpeak_13CO.fits",data,hdr
;    fits_read,'Vcenter_13CO.fits',vdata,vhdr
;    validdata=data[where(tex lt 46.3205 and vdata gt -30 and vdata lt 75, count)]
;;    validdata=validdata[where(finite(validdata))]
;    help,validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    pson
;        device,filename='Nco_13CO_Tpeak_his.eps',/encapsulated
;        device,/portrait
;         peak = max(histogram(validdata))/120000d
;        plothist,validdata,bin=5e16, peak = peak, /boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(!E13!NCO) PDF of NGC 2264, T!Ipeak!N',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-2e17,1e18],yrange=[1e-6,1]
;        device,/close_file
;    psoff
;
;print,"Nco Histogram: Nco_C18O_Tpeak_his.eps"
;    fits_read,"Nco_Tpeak_C18O.fits",data,hdr
;    fits_read,'Vcenter_C18O.fits',vdata,vhdr
;    validdata=data[where(tex lt 46.3205 and vdata gt -30 and vdata lt 75, count)]
;    help,validdata
;    validdata=validdata[where(finite(validdata))]
;    help,validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    pson
;        device,filename='Nco_C18O_Tpeak_his.eps',/encapsulated
;        device,/portrait
;         peak = max(histogram(validdata))/120000d
;        plothist,validdata,bin=5e16, peak = peak, /boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(C!E18!NO) PDF of NGC 2264, T!Ipeak!N',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-2e17,1e18],yrange=[1e-6,1]
;        device,/close_file
;    psoff
;
;
;
;print,"Nco Histogram: Nco_13CO_tau_his.eps"
;    fits_read,"Nco_tau_13CO.fits",data,hdr
;    fits_read,'Vcenter_13CO.fits',vdata,vhdr
;    fits_read,"tau_13CO.fits",taudata,tauhdr
;    validdata=data[where(tex lt 46.3205 and vdata gt -30 and vdata lt 75 and finite(taudata), count)]
;    help,validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    pson
;        device,filename='Nco_13CO_tau_his.eps',/encapsulated
;        device,/portrait
;         peak = max(histogram(validdata))/120000d
;        plothist,validdata,bin=5e16, peak = peak, /boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(!E13!NCO) PDF of NGC 2264, !7s!X',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-2e17,1e18],yrange=[1e-6,1]
;        device,/close_file
;    psoff
;
;print,"Nco Histogram: Nco_C18O_tau_his.eps"
;    fits_read,"Nco_tau_C18O.fits",data,hdr
;    fits_read,'Vcenter_C18O.fits',vdata,vhdr
;    fits_read,"tau_C18O.fits",taudata,tauhdr
;    validdata=data[where(tex lt 46.3205 and vdata gt -30 and vdata lt 75 and finite(taudata), count)]
;    help, validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    pson
;        device,filename='Nco_C18O_tau_his.eps',/encapsulated
;        device,/portrait
;         peak = max(histogram(validdata))/120000d
;        plothist,validdata,bin=5e16, peak = peak, /boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(C!E18!NO) PDF of NGC 2264,!7s!X',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-2e17,1e18],yrange=[1e-6,1]
;        device,/close_file
;    psoff



; .compile n_h2
;n_h2, '12CO', '12co_-10_40_int.fits', outfile='N_H2_Wco_12CO.fits'
;n_h2, '13CO', 'Nco_13co_-10_35_int.fits', outfile='N_H2_Nco_13CO.fits'
;n_h2, 'C18O', 'Nco_c18o_1_12_int.fits', outfile='N_H2_Nco_c18o_1_12_int.fits'
;n_h2, '13CO', 'Nco_Tpeak_13CO.fits', outfile='N_H2_Nco_Tpeak_13CO.fits'
;n_h2, 'C18O', 'Nco_Tpeak_C18O.fits', outfile='N_H2_Nco_Tpeak_C18O.fits'
;n_h2, '13CO', 'Nco_tau_13CO.fits', outfile='N_H2_Nco_tau_13CO.fits'
;n_h2, 'C18O', 'Nco_tau_C18O.fits', outfile='N_H2_Nco_tau_C18O.fits'

;print,"N_H2 Histogram: N_H2_12CO_his.eps"
;    fits_read,"N_H2_12co_-10_40_int.fits",data,hdr
;print,'Mass: ', mass(data,distance), ' Msun from 12CO x-factor'
;    validdata=data[where(data lt 4.326871e+25, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'Mass: ', mass(data,distance), ' Msun from 12CO x-factor'
;;    print, 'above noise: ', size(where(validdata gt 4.4002))
;    pson
;        device,filename='N_H2_12CO_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1e24,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(H!I2!N) from !E12!NCO PDF of NGC 2264',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-2e25,6e25],yrange=[0.5,1e6]
;;        cgplots,[1,1]*4.4002,[0.1,1e5],linestyle=2
;;        cgtext,4.4002,2e5,'Tex(3 sigma)',charsize=1
;        device,/close_file
;    psoff
;
;print,"N_H2 Histogram: N_H2_13CO_his.eps"
;    fits_read,"N_H2_13co_-10_35_int.fits",data,hdr
;print,'Mass: ', mass(data,distance), ' Msun from 13CO column density'
;    validdata=data[where(data lt 4.326871e+26, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'Mass: ', mass(data,distance), ' Msun from 13CO column density'
;    pson
;        device,filename='N_H2_13CO_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1e24,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(H!I2!N) from !E13!NCO PDF of NGC 2264',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-2e25,8e25],yrange=[0.5,1e6]
;        device,/close_file
;    psoff
;
;print,"N_H2 Histogram: N_H2_C18O_his.eps"
;    fits_read,"N_H2_c18o_0_10_int.fits",data,hdr
;    validdata=data[where(data lt 4.326871e+26, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    pson
;        device,filename='N_H2_C18O_0_10_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1e24,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(H!I2!N) from C!E18!NO PDF of NGC 2264',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-3e25,1.4e26],yrange=[0.5,1e6]
;        device,/close_file
;    psoff
;    fits_read,"N_H2_c18o_1_12_int.fits",data,hdr
;print,'Mass: ', mass(data,distance), ' Msun from C18O column density'
;    validdata=data[where(data lt 4.326871e+23, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'Mass: ', mass(data,distance), ' Msun from C18O column density'
;    pson
;        device,filename='N_H2_C18O_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1e21,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(H!I2!N) from C!E18!NO PDF of NGC 2264',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-3e22,1.4e23],yrange=[0.5,1e6]
;        device,/close_file
;    psoff

;print,"N_H2 Histogram: N_H2_13CO_Tpeak_his.eps"
;    fits_read,"N_H2_Nco_Tpeak_13CO.fits",data,hdr
;    fits_read,'Vcenter_13CO.fits',vdata,vhdr
;    validdata=data[where(tex lt 46.3205 and vdata gt -30 and vdata lt 75, count)]
;;    validdata=validdata[where(finite(validdata))]
;    help,validdata
;    print,'Mass: ', mass(validdata,distance), ' Msun from 13CO column density'
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    pson
;        device,filename='N_H2_13CO_Tpeak_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1e21,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(H!I2!N) from !E13!NCO PDF of NGC 2264, T!Ipeak!N',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-2e22,8e22],yrange=[0.5,1e6]
;        device,/close_file
;    psoff

;print,"N_H2 Histogram: N_H2_C18O_Tpeak_his.eps"
;    fits_read,"N_H2_Nco_Tpeak_C18O.fits",data,hdr
;    fits_read,'Vcenter_C18O.fits',vdata,vhdr
;    validdata=data[where(tex lt 46.3205 and vdata gt -30 and vdata lt 75, count)]
;    help,validdata
;    validdata=validdata[where(finite(validdata))]
;    help,validdata
;    print,'Mass: ', mass(validdata,distance), ' Msun from C18O column density'
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    pson
;        device,filename='N_H2_C18O_Tpeak_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1e21,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(H!I2!N) from C!E18!NO PDF of NGC 2264, T!Ipeak!N',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-2e22,15e22],yrange=[0.5,1e6]
;        device,/close_file
;    psoff



;print,"N_H2 Histogram: N_H2_13CO_tau_his.eps"
;    fits_read,"N_H2_Nco_tau_13CO.fits",data,hdr
;    fits_read,'Vcenter_13CO.fits',vdata,vhdr
;    fits_read,"tau_13CO.fits",taudata,tauhdr
;    validdata=data[where(tex lt 46.3205 and vdata gt -30 and vdata lt 75 and finite(taudata), count)]
;    help,validdata
;    print,'Mass: ', mass(validdata,distance), ' Msun from 13CO column density'
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    pson
;        device,filename='N_H2_13CO_tau_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1e21,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(H!I2!N) from !E13!NCO PDF of NGC 2264, !7s!X',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-2e22,8e22],yrange=[0.5,1e6]
;        device,/close_file
;    psoff
;
;print,"N_H2 Histogram: N_H2_C18O_tau_his.eps"
;    fits_read,"N_H2_Nco_tau_C18O.fits",data,hdr
;    fits_read,'Vcenter_C18O.fits',vdata,vhdr
;    fits_read,"tau_C18O.fits",taudata,tauhdr
;    validdata=data[where(tex lt 46.3205 and vdata gt -30 and vdata lt 75 and finite(taudata), count)]
;    help, validdata
;    print,'Mass: ', mass(validdata,distance), ' Msun from C18O column density'
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    pson
;        device,filename='N_H2_C18O_tau_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1e21,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(H!I2!N) from C!E18!NO PDF of NGC 2264,!7s!X',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-3e22,15e22],yrange=[0.5,1e6]
;        device,/close_file
;    psoff



;print, 'Compare 12CO and 13CO:'
;    fits_read, 'tpeak.fits', img_c, hdr_c
;    fits_read, 'tpeak_13CO.fits', img, hdr
;    pson
;        device, filename='Compare_Tpeak.eps', /encapsulated
;        device, /portrait
;            cgimage,img,/keep_aspect, position = pos
;            imcontour,img_c,hdr_c,nlevels=7,/Noerase,/TYPE,position = pos
;        device, /close_file
;    psoff

;print, 'Abundance Ratio:'
;;    fits_read, 'Nco_13co_-10_35_int.fits', N_13CO, N_13CO_hdr
;;    fits_read, 'Nco_c18o_1_12_int.fits', N_C18O, N_C18O_hdr
;;    data=N_13CO/N_C18O
;;    hdr =N_13CO_hdr
;;    fits_write,'AbundanceRatio_13_18.fits', data, hdr
;;    fits_read, 'Nco_Tpeak_13CO.fits', N_13CO, N_13CO_hdr
;;    fits_read, 'Nco_Tpeak_C18O.fits', N_C18O, N_C18O_hdr
;;    data=N_13CO/N_C18O
;;    hdr =N_13CO_hdr
;;    fits_write,'AbundanceRatio_13_18_Tpeak.fits', data, hdr
;;    fits_read, 'Nco_tau_13CO.fits', N_13CO, N_13CO_hdr
;;    fits_read, 'Nco_tau_C18O.fits', N_C18O, N_C18O_hdr
;;    data=N_13CO/N_C18O
;;    hdr =N_13CO_hdr
;;    fits_write,'AbundanceRatio_13_18_tau.fits', data, hdr

;    fits_read, 'AbundanceRatio_13_18.fits', data, hdr
;    fits_read, 'Tex.fits', tex, texhdr
;    validdata=data[where(tex lt 46.3205, count)]
;    help, validdata
;    print,'     Sum           Maximum     Minimum      Mean'
;    image_statistics, validdata, count=count, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    validdata=validdata[where(validdata gt -100 and validdata lt 100)]
;    help, validdata
;    pson
;        device,filename='AbundanceRatio_13_18_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='Abundence Ratio !E13!NCO/C!E18!NO PDF of NGC 2264',xtitle='Abundance Ratio',ytitle='Number'$
;               ,/ylog,xrange=[-1e2,1e2],yrange=[0.5,1e6]
;        cgplots,[1,1],[0.1,1e5],linestyle=2
;        cgtext,1.4002,2e5,'ratio=1',charsize=1     
;        device,/close_file
;    psoff
;    fits_read, 'AbundanceRatio_13_18_Tpeak.fits', data, hdr
;    fits_read, 'Tex.fits', tex, texhdr
;    fits_read, 'Vcenter_13CO.fits', vdata13, vhdr13
;    fits_read, 'Vcenter_C18O.fits', vdata18, vhdr18
;    validdata=data[where(tex lt 46.3205 and vdata13 gt -30 and vdata13 lt 75 and vdata18 gt -30 and vdata18 lt 75 , count)]
;    help, validdata
;    print,'     Sum           Maximum     Minimum      Mean'
;    image_statistics, validdata, count=count, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    validdata=validdata[where(validdata gt -100 and validdata lt 100)]
;    help, validdata
;    pson
;        device,filename='AbundanceRatio_13_18_Tpeak_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='Abundence Ratio !E13!NCO/C!E18!NO PDF of NGC 2264',xtitle='Abundance Ratio',ytitle='Number'$
;               ,/ylog,xrange=[-1e2,1e2],yrange=[0.5,1e6]
;        cgplots,[1,1],[0.1,1e5],linestyle=2
;        cgtext,1.4002,2e5,'ratio=1',charsize=1     
;        device,/close_file
;    psoff
;    fits_read, 'AbundanceRatio_13_18_tau.fits', data, hdr
;    fits_read, 'Tex.fits', tex, texhdr
;    fits_read, 'Vcenter_13CO.fits', vdata13, vhdr13
;    fits_read, 'Vcenter_C18O.fits', vdata18, vhdr18
;    fits_read, 'tau_13CO.fits', taudata13, tauhdr13
;    fits_read, "tau_C18O.fits", taudata18, tauhdr18
;    validdata=data[where(tex lt 46.3205 and vdata13 gt -30 and vdata13 lt 75 and vdata18 gt -30 and vdata18 lt 75 and finite(taudata13) and finite(taudata18), count)]
;    help, validdata
;    print,'     Sum           Maximum     Minimum      Mean'
;    image_statistics, validdata, count=count, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    validdata=validdata[where(validdata gt -100 and validdata lt 100)]
;    help, validdata
;    pson
;        device,filename='AbundanceRatio_13_18_tau_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=2,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='Abundence Ratio !E13!NCO/C!E18!NO PDF of NGC 2264',xtitle='Abundance Ratio',ytitle='Number'$
;               ,/ylog,xrange=[-1e3,1e3],yrange=[0.5,1e6]
;        cgplots,[1,1],[0.1,1e5],linestyle=2
;        cgtext,1.4002,2e5,'ratio=1',charsize=1     
;        device,/close_file
;    psoff

;cubemoment, 'ngc226412cofinal.fits', [-1,2], direction='B'
;cubemoment, 'ngc226412cofinal.fits', [-1,2], direction='L'
;cubemoment, 'ngc226413cofinal.fits', [-1,2], direction='B'
;cubemoment, 'ngc226413cofinal.fits', [-1,2], direction='L'
;cubemoment, 'ngc2264c18ofinal.fits', [-1,2], direction='B'
;cubemoment, 'ngc2264c18ofinal.fits', [-1,2], direction='L'

