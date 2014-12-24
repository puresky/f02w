;+
;  :Description:
;       This script is used to calculate FWHM of spectrum from data cube.
;
;       FWHM = (8 ln(2))^(1/2) sigma
;       Usage:
;           .compile fwhm.pro
;           pdf_plot,"infilename"[, outfile="FWHM.fits", v_range=[-50,50]]
;  :Output:
;           file: FWHM.fits
;                 Position.fits
;                 Qulity.fits
;  :Todo:
;    advanced function of the routine
;    additional function of the routine
;  :Categories:
;    type of the routine
;  :Uses:
;    .pro
;  :Params:
;    x : in, required, type=fltarr
;       independent variable
;    y : in, required, type=fltarr
;       dependent variable
;  :Keywords:
;    keyword1 : In, Type=float
;    keyword2 : In, required
;  :Author: puresky
;  :History:
;    V0     2014年9月20日 13:30:29
;    V0.1   2014年9月20日 13:30:54
;    V1.0   2014-09-22
;    V1.1   Mon Sep 22 19:50:49 CST 2014
;
;-

pro pdf_plot, quantity, identifier, noiselevel, infile=infile, outfile=outfile, v_center_file = v_center_file, v_range=v_range, quality_file=quality_file, sigma_file=sigma_file ;estimates=estimates
    if n_params() lt 1 then begin
        print, 'Syntax - fwhm, infile [, outfile= ][, v_range= ]'
        print, 'velocities in km/s'
        return
    endif
    if ~keyword_set(infile) then infile=+'_'+identifier+'.fits'
    if ~keyword_set(outfile) then outfile='FWHM_'+infile
    if ~keyword_set(v_center_file) then v_center_file = 'Vcenter_'+infile 
    if ~keyword_set(v_range) then v_range=[-50,50]
;    if ~keyword_set(estimates) then estimates=[1,mean(v_range),0,0,0,0]
    if ~keyword_set(quality_file) then quality_file='Quality_FWHM_'+infile
    if ~keyword_set(sigma_file) then sigma_file = 'Sigma_FWHM_'+infile

    print, 'search velocity range: ',v_range
    print, 'infile is "'+infile+'", outfile is "'+outfile+'"'
    print, 'position log file is "'+v_center_file+'"'
    print, 'fitting quality log file is "'+quality_file+'"'
    print, 'sigma log file is "'+sigma_file+'"'

    fits_read,infile,data,hdr
;    fits_read,Tpeak_file,Tdata,Thdr
;    fits_read,Vest_file, Vest,Vesthdr
;    fits_read,Vdisperion_file,Vdispersion,Vdhdr

;    P_former = !P 
;    !P.charsize=1.4 & !P.charthick=2 & !P.thick=2
;    !X.thick=2 & !Y.thick=2
;        !X.margin=[8,8] &  !Y.margin=[4,4] 

;;;;Log
;    print,quantity+' '+identifier+" Histogram"
;        fits_read,"tpeak.fits",data,hdr
    validdata=data[where(data lt 42.7905, count)]
    help,validdata
    image_statistics, validdata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
    print, 'raw data statistics:   sum   max   min   mean',data_sum,data_max,data_min,data_mean
    noiselevel = 3 * Tmb_12CO_rms
    signaldata = validdata(where(validdata ge noiselevel))
    help, signaldata
    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
    print,'Above 3 sigma statistics:	sum	max	min 	mean', data_sum, data_max, data_min, data_mean
    
;         !P.multi = [1,1,2] & !Y.OMARGIN=[1,0]
;            device,filename='tpeak_his.eps',/encapsulated
    logdata=alog(signaldata/data_mean)
    binsize=0.1 & xrange =[-2,3] & yrange =[3e-4,3]
    Nsamples=n_elements(logdata)
    yhist = cgHistogram(logdata, binsize=binsize, min=alog(noiselevel/data_mean), locations=xhist, /frequency)/binsize
    xhist = xhist + 0.5*binsize
    peak = max(yhist,max_subscript)
    yfit = GaussFit(xhist[0:11], yhist[0:11], coeff, NTERMS=3, chisq=chisquare)
    print, 'peak =', peak, '    peak_subscript =', max_subscript
    print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
    cgPlot, [xhist[0]-binsize,xhist,max(xhist)+binsize], [0,yhist,0] $
          , psym=10, xstyle=9, ystyle=9 $
          , xtitle=textoidl('ln(T_{peak}/<T_{peak}>)'), ytitle='P(s)' $
          , /ylog, xrange=xrange, yrange=yrange, ytickformat='logticks_exp'
    cgColorFill, [xrange[0]*[1,1],alog(noiselevel/data_mean)*[1,1]],[yrange,reverse(yrange)], color='grey'
    cgOplot, xhist, yfit, color='green'
    cgPlots, [1,1]*alog(noiselevel/data_mean),yrange,linestyle=2
    cgAxis,xaxis=0,xstyle=1
    cgAxis,xaxis=1,xstyle=1, xrange=exp(xrange)*data_mean, /xlog
    cgText, mean(!X.Window), 0.48, /normal, alignment=0.5 $
          , textoidl('T_{peak} (K)')
    cgAxis,yaxis=0,ystyle=1, ytickformat='logticks_exp', yrange=yrange
    cgAxis,yaxis=1,ystyle=1, ytickformat='logticks_exp', yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
    cgText, mean(!X.window), 0.52, /normal, alignment=0.5   , charsize=2 $
          , 'T!Ipeak !N!E12!NCO PDF of NGC 2264'
    cgText, xrange[1]-1.5, yrange[1]/10.0, textoidl('\sigma = ')+string(coeff[2], format='(f0.2)')
;    device,/close_file


;;;;Natural

    binsize=1e21 & xrange=[-2e22,6e22] & yrange=[1e-27,1e-21]
    Nsamples=n_elements(validdata)
    yhist = HISTOGRAM( validdata , BINSIZE=binsize, LOCATIONS=xhist, MIN=floor(min(validdata)) ) 
    yhist = float(yhist)/Nsamples/binsize
    peak = max(yhist,max_subscript)
    print, 'peak =', peak, '   peak_subscript =', max_subscript
    cgPlot, xhist,yhist,/nodata,xstyle=1,ystyle=9$
          , charsize=1.4, charthick=2, xthick=2, ythick=2 $
          , xtitle='Conlumn Densities (cm!E-2!N)',ytitle='P(s)' $
          , /ylog,xrange=xrange,yrange=yrange,ytickformat='logticks_exp'
    cgColorFill, [xrange[0],xrange[0],noiselevel,noiselevel],[yrange,reverse(yrange)], color='grey'
    plothist, validdata, bin=binsize, peak=peak $
            , charsize=1.4, charthick=2, xthick=2, ythick=2 $
            , /overplot
    yhist = HISTOGRAM( validdata , BINSIZE=binsize, LOCATIONS=xhist, MIN=0 ) 
    yhist = float(yhist)/Nsamples/binsize
    xhist = xhist + binsize/2d
    yfit = gaussfit(alog(xhist[0:30]),(yhist*xhist)[0:30],coeff,chisq=chisquare,nterms=3)/xhist
     yfit = gaussfit(alog(xhist),yhist*xhist,coeff,chisq=chisquare,nterms=3)/xhist
    print, 'A, mu, sigma:', coeff & print, 'chi square=',chisquare
    cgOplot,xhist,yfit,color='green'
    cgAxis,xaxis=0,xstyle=1,charsize=1.4, xrange=xrange
    cgAxis,xaxis=1,xstyle=1,charsize=0.01
    cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=yrange,ytickformat='logticks_exp'
    cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
    cgplots,[1,1]*noiselevel, yrange, linestyle=2


;!P = P_former
