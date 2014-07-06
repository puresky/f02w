;+
; Project     : VSO
;
; Name        : BROWSER_AGENT
;
; Purpose     : Fake HTTP user-agent string to trick server into
;               thinking that a valid browser client is being used.
;
; Inputs      : None
;
; Outputs     : User-Agent string
;
; Keywords    : None
;
; History     : 15-January-2012, Zarro (ADNET) - written
;
; Contact     : DZARRO@SOLAR.STANFORD.EDU
;-

function browser_agent

agentStr= 'Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120606 Firefox/10.0.5'
return,agentStr

end
