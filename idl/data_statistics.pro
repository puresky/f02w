;+
;  :Description:
;    Show statistics of data.
;  :Syntax:
;    
;    Input:
;    Output:
;      file     : 
;      variable :
;  :Todo:
;    advanced function of the routine
;    additional function of the routine
;  :Categories:
;    type of the routine
;  :Uses:
;    .pro
;  :See Also:
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
;    V0     2015-01-26        Modified from IDL Demo Pro CalculatingStatistics.
;    V0.1   2015-09-20 
;    V1.0 
;
;-
;Comment Tags:
;    http://www.exelisvis.com/docs/IDLdoc_Comment_Tags.html
;
;


PRO Data_Statistics, data
    
    IF !D.window ge 0 THEN  Wshow ELSE WINDOW
    Data_Dimension = size(data)
    if Data_Dimension[0] eq 1 then plot, data 
    if Data_Dimension[0] eq 2 then begin
        ; Initialize the display.
        DEVICE, DECOMPOSED = 0
        LOADCT, 27
    
        ; Create a window and display the image.
        WINDOW, !D.window, XSIZE = Data_Dimension[1], YSIZE = Data_Dimension[2], $
                TITLE = 'Data Visualization'
        TV, data
    endif
    ; Determine the statistics of the image.
    IMAGE_STATISTICS, data, COUNT = DataCounts, $
                      DATA_SUM = DataSum, MAXIMUM = DataMax, $
                      MEAN = DataMean, MINIMUM = DataMin, $
                      STDDEV = DataDeviation, $
                      SUM_OF_SQUARES = DataSquareSum, $
                      VARIANCE = DataVariance
    
    ; Print out the resulting statistics.
    PRINT, ''
    PRINT, 'IMAGE STATISTICS:'
    PRINT, 'Counts of Data Set= ', DataCounts
    PRINT, 'Sum of Data Set = ', DataSum
    PRINT, 'Maximum Data = ', DataMax
    PRINT, 'Mean of Data Set = ', DataMean
    PRINT, 'Minimum of Data = ', DataMin
    PRINT, 'Standard Deviation of Data Set = ', DataDeviation
    PRINT, 'Total of Squared Data = ', DataSquareSum
    PRINT, 'Variance of Data Set = ', DataVariance
    
END
