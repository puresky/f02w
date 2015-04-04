;+
;  :Description:
;       This script is used to plot Probability Density Distribution of the input data.
;
;       Usage:
;           .compile pdf_plot.pro
;           pdf_plot, rawdata, threshold[, binsize= , xrange=[-10,50],]
;  :Output:
;           file: 
;                 
;                 
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
;    log : In, optional. If this keyword is set and the parameter threshold is set to be no more than 0, greyed mask region will not be plot.
;  :Author: puresky
;  :History:
;    V0     2015-01-06        Log-log diagram realised.
;    V0.1   2015-01-29        Grayed region plot optional.
;    V1.0   2015-09-22
;    V1.1   
;
;-

pro pdf_plot, rawdata, threshold, log=log, binsize=binsize, xrange=xrange, yrange=yrange, $
              title=title, x_log_title=x_log_title, y_probability_title=y_probability_title, x_natural_title=x_natural_title, y_count_title=y_count_title, $
              fitting=fitting, fit_range=fit_range

    if n_params() lt 2 then begin
        print, 'Syntax - pdf_plot, rawdata, threshold[, /log][, binsize= ][, xrange= ][, yrange= ][, /fit][, fit_range= ]'
        print, ''
        return
    endif
    if ~keyword_set(binsize) then print,'keyword binsize is not defined, use default way'
;    if ~keyword_set(title) then title=''
;    if ~keyword_set(v_center_file) then v_center_file = 'Vcenter_'+infile 
;    if ~keyword_set(fit_range) then fit_range=[-50,50]
;    if ~keyword_set(estimates) then estimates=[1,mean(v_range),0,0,0,0]
;    if ~keyword_set(quality_file) then quality_file='Quality_FWHM_'+infile
;    if ~keyword_set(sigma_file) then sigma_file = 'Sigma_FWHM_'+infile

;    print, 'search velocity range: ',v_range
;    print, 'infile is "'+infile+'", outfile is "'+outfile+'"'
;    print, 'position log file is "'+v_center_file+'"'
;    print, 'fitting quality log file is "'+quality_file+'"'
;    print, 'sigma log file is "'+sigma_file+'"'

;    fits_read,infile,data,hdr
;    fits_read,Tpeak_file,Tdata,Thdr
;    fits_read,Vest_file, Vest,Vesthdr
;    fits_read,Vdisperion_file,Vdispersion,Vdhdr

    print, "Basic Data Information:"
    help,rawdata
    image_statistics, rawdata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
    print, 'Raw data statistics:       sum       max       min       mean'
    print, '                   ', data_sum, data_max, data_min, data_mean
    signaldata = rawdata[where(rawdata ge threshold)]
    help, signaldata
    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
    print, 'Above threshold (i.e. 3 sigma) statistics:  sum       max	   min 	     mean'
    print, '                   ', data_sum, data_max, data_min, data_mean
        
    if keyword_set(log) then begin
    ;'Log': begin
        logdata=alog(signaldata/data_mean)
        Nsamples=n_elements(logdata)
        yhist = cgHistogram(logdata, binsize=binsize, min=alog((threshold gt 0?threshold:data_min)/data_mean), locations=xhist, /frequency)/binsize
        xhist = xhist + 0.5*binsize    ; move to center of bin  
        peak = max(yhist,max_subscript)
        print, 'peak =', peak, '    peak_subscript =', max_subscript
        cgPlot, [xhist[0]-binsize,xhist,max(xhist)+binsize], [0,yhist,0] $
              , psym=10, xstyle=9, ystyle=9 $
              , xtitle=x_log_title $ ;, xtitle=textoidl('ln(T_{peak}/<T_{peak}>)')
              , ytitle='P(s)' $ ;, ytitle=y_probability_title $ 
              , /ylog, xrange=xrange, yrange=yrange, ytickformat='logticks_exp'
        if threshold gt 0 then cgColorFill, [xrange[0]*[1,1],alog(threshold/data_mean)*[1,1]],[yrange,reverse(yrange)], color='grey'
        if keyword_set(fitting) then begin
            if keyword_set(fit_range) then begin
                yfit = GaussFit(xhist[fit_range[0]:fit_range[1]], yhist[fit_range[0]:fit_range[1]], coeff, NTERMS=3, chisq=chisquare)
            endif else begin
                yfit = GaussFit(xhist, yhist, coeff, NTerms=3, Chisq=chisquare)
            endelse
            print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
            x_extra = xhist[0]+binsize*indgen(100)
            yfit_extra = coeff[0]*exp(-((x_extra-coeff[1])/coeff[2])^2/2.0)
            cgOplot, x_extra, yfit_extra, color='green', linestyle=2
            cgOplot, xhist, yfit, color='green'
;            cgOplot, xhist-1, coeff[0]*exp(-((xhist-coeff[1])/coeff[2])^2/2.0)
            print, 'Is it equal to 1?', binsize*[total(yhist),total(yfit),total(yfit_extra)]
            Ord = total(yhist-yfit_extra)*binsize
            Cov = 1.0 - total(yfit)*binsize
            print, 'Coverage, Orderence',Cov, Ord
            cgText, [[0.25],[0.75]]#!X.Window, [[0.15],[0.85]]#!Y.Window, /normal, textoidl('\sigma = ')+string(coeff[2], format='(f0.2)')
;            cgText, [[0.35],[0.65]]#!X.Window, [[0.20],[0.80]]#!Y.Window, /normal, textoidl('<N> = ')+string(data_mean, format='(f0.2)')
            cgText, [[0.29],[0.71]]#!X.Window, [[0.22],[0.78]]#!Y.Window, /normal, textoidl('Ord = ')+string(Ord, format='(f0.2)')
            ;cgText, 
        endif
        if threshold gt 0 then cgPlots, [1,1]*alog(threshold/data_mean),yrange,linestyle=2
        cgAxis,xaxis=0,xstyle=1
        cgAxis,xaxis=1,xstyle=1, xrange=exp(xrange)*data_mean, /xlog
        cgText, mean(!X.Window), 0.48, /normal, alignment=0.5, x_natural_title 
        cgAxis,yaxis=0,ystyle=1, ytickformat='logticks_exp', yrange=yrange
        cgAxis,yaxis=1,ystyle=1, ytickformat='logticks_exp', yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
        cgText, mean(!X.window), 0.52, /normal, alignment=0.5   , charsize=2, title 
    endif else begin    
    ;'Natural': begin
        binsize=1e21 & xrange=[-2e22,6e22] & yrange=[1e-27,1e-21]
        Nsamples=n_elements(rawdata)
        yhist = HISTOGRAM(rawdata , BINSIZE=binsize, LOCATIONS=xhist, MIN=floor(min(rawdata)) ) 
        yhist = float(yhist)/Nsamples/binsize
        peak = max(yhist,max_subscript)
        print, 'peak =', peak, '   peak_subscript =', max_subscript
        cgPlot, xhist,yhist,/nodata,xstyle=1,ystyle=9$
              , charsize=1.4, charthick=2, xthick=2, ythick=2 $
              , xtitle='Conlumn Densities (cm!E-2!N)',ytitle='P(s)' $
              , /ylog,xrange=xrange,yrange=yrange,ytickformat='logticks_exp'
        cgColorFill, [xrange[0],xrange[0],threshold,threshold],[yrange,reverse(yrange)], color='grey'
        plothist, rawdata, bin=binsize, peak=peak $
                , charsize=1.4, charthick=2, xthick=2, ythick=2 $
                , /overplot
        yhist = HISTOGRAM(rawdata , BINSIZE=binsize, LOCATIONS=xhist, MIN=0 ) 
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
        cgplots,[1,1]*threshold, yrange, linestyle=2
    endelse


end
