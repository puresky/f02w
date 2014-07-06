	PRO OPLOT_STRING,P1,P2,P3,LINE=LINE,COLOR=COLOR,CHARSIZE=CHAR_SIZE
;+
; Project     :	SOHO - CDS
;
; Name        :	
;	OPLOT_STRING
; Purpose     :	
;	Overplot an X,Y array using a character string as a symbol.
; Explanation :	
;	If /LINE is selected, then OPLOT is called with a plotting symbol of
;	zero.  Finally, XYOUTS is called to draw the string at the X,Y
;	coordinates.
; Use         :	
;	OPLOT_STRING,  [ X, ]  Y, STRING
; Inputs      :	
;	Y	= Y array, as in PLOT,Y or PLOT,X,Y
;	STRING	= Character string to use as plotting symbol, e.g. "A".  If a
;		  number is passed, then it is converted into a string.
; Opt. Inputs :	
;	X	= X array, as in PLOT,X,Y
; Outputs     :	
;	None.
; Opt. Outputs:	
;	None.
; Keywords    :	
;	LINE	= If present and non-zero, then connecting lines are drawn
;		  between data points.
;	COLOR	= Color used for the plotting symbol, and for any connecting
;		  lines between data points.
;	CHARSIZE= Character size to use for the character plotting symbol.
; Calls       :	
;	TRIM
; Common      :	
;	None.
; Restrictions:	
;	X and Y must be arrays.  STRING must be a character string scalar.
; Side effects:	
;	None.
; Category    :	
;	Utilities, Graphics.
; Prev. Hist. :	
;	W.T.T., May, 1990.
;	William Thompson, Nov 1992, modified algorithm for getting the relative
;		character size.
; Written     :	
;	William Thompson, GSFC, May 1990.
; Modified    :	
;	Version 1, William Thompson, GSFC, 9 July 1993.
;		Incorporated into CDS library.
;		Adjusted vertical spacing to better center characters.
;		Fixed bug with logarithmic plots.
;	Version 2, William Thompson, GSFC, 18 December 2002
;		Changed !COLOR to !P.COLOR
; Version     :	
;	Version 2, 18 December 2002
;-
;
	ON_ERROR,2
;
;  Check the input parameters.
;
	CASE N_PARAMS(0) OF
		2:  BEGIN			;Only Y and STRING passed.
			X_PASSED = 0
			Y = P1
			STRING = P2
			END
		3:  BEGIN			;X, Y and STRING passed.
			X_PASSED = 1
			X = P1
			Y = P2
			STRING = P3
			END
		ELSE:  BEGIN
			PRINT,'*** OPLOT_STRING must be called with 1-3 parameters:'
			PRINT,'            [ X, ]  Y, STRING'
			PRINT,'  Optional keywords:  LINE, COLOR
			RETURN
			END
	ENDCASE
;
;  Check the number of elements of X, and Y.
;
	IF X_PASSED THEN IF N_ELEMENTS(X) LT 2 THEN BEGIN
		PRINT,'*** Variable must be an array, name= X, routine OPLOT_STRING.'
		RETURN
	ENDIF
	IF N_ELEMENTS(Y) LT 2 THEN BEGIN
		PRINT,'*** Variable must be an array, name= Y, routine OPLOT_STRING.'
		RETURN
	ENDIF
;
;  Check the size and type of STRING.
;
	IF N_ELEMENTS(STRING) NE 1 THEN BEGIN
		PRINT,'*** Variable must be a scalar, name= STRING, routine OPLOT_STRING.'
		RETURN
	ENDIF
	SZ_STRING = SIZE(STRING)
	IF SZ_STRING(SZ_STRING(0) + 1) NE 7 THEN STRING = TRIM(STRING)
;
;  If desired, draw connecting lines between data points.
;
	IF N_ELEMENTS(COLOR) LE 0 THEN COLOR = !P.COLOR
	IF NOT X_PASSED THEN X = INDGEN(N_ELEMENTS(Y))
	IF KEYWORD_SET(LINE) THEN OPLOT,X,Y,PSYM=0,COLOR=COLOR
;
;  Get the relative character size.
;
	IF N_ELEMENTS(CHAR_SIZE) EQ 1 THEN CHARSIZE = CHAR_SIZE	$
		ELSE CHARSIZE = !P.CHARSIZE
	IF CHARSIZE LE 0 THEN CHARSIZE = 1
;
;  Draw the character string as the plotting symbol.
;
	N = N_ELEMENTS(X) < N_ELEMENTS(Y)
	DEV = CONVERT_COORD(X,Y,/DATA,/TO_DEVICE)
	XX = DEV(0,*)
	YY = DEV(1,*) - 0.25*CHARSIZE*!D.Y_CH_SIZE
	XMIN = !P.CLIP(0)  &  XMAX = !P.CLIP(2)
	YMIN = !P.CLIP(1)  &  YMAX = !P.CLIP(3)
	FOR I = 0,N-1 DO IF (XX(I) GE XMIN) AND (XX(I) LE XMAX) AND	$
		(YY(I) GE YMIN) AND (YY(I) LE YMAX) THEN		$
		XYOUTS,XX(I),YY(I),STRING,ALIGNMENT=0.5,COLOR=COLOR,	$
			CHARSIZE=CHARSIZE,/DEVICE
;
	RETURN
	END
