(* ::Package:: *)

(* ::Section:: *)
(*FRW Analog Model*)


$Assumptions=.//Quiet;
$Assumptions=Join[Thread[{labTime,timeScale,waveNumber,\[HBar],interactionStrength[0],soundSpeed[0]}>0],{-2timeScale<\[Eta]<0}];


Clear[interactionStrength,soundSpeed,dispersion,expansion]
(*eq 26*)interactionStrength[timeScale_][labTime_]:=interactionStrength[0]scaling["Lab",timeScale][labTime]
(*eq 27*)soundSpeed[timeScale_][labTime_]:=soundSpeed[0]Sqrt@scaling["Lab",timeScale][labTime]
(*eq 23*)dispersion[timeScale_][labTime_,waveNumber_]:=soundSpeed[timeScale][labTime]waveNumber
(*eq 31*)expansion[dimension_,timeScale_][finalTime_]:=With[{\[Alpha]=(dimension-2)/(dimension-1)},scaling[timeScale][finalTime]^(\[Alpha]-1)]
