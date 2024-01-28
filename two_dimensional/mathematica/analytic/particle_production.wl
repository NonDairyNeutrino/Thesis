(* ::Package:: *)

(* ::Section:: *)
(*Particle Production*)


Clear@particleProduction
(*eq 88*)particleProduction[initialDensity_,timeScale_][labTime_,waveNumber_]:=Abs[#]^2&@Det@Table[
Conjugate@mixedFourierAmplitude[reg,op,initialDensity,timeScale][labTime,waveNumber],
{reg,{"out","exp"}},
{op,{Plus,Subtract}}
]
