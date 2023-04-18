(* ::Package:: *)

(* ::Subsection:: *)
(*Multiple Time Scales*)


(* ::Input:: *)
(*Clear@nonDimTimeScaleList*)
(*nonDimTimeScaleList=N@{1 10^-5,2 10^-5,5 10^-5,1 10^-4,1 10^-3};*)


(* ::Input:: *)
(*Clear@fig2*)
(*fig2=Block[*)
(*{n0=10^7,*)
(*boxLength=1,*)
(*m=1,*)
(*\[HBar]=1,*)
(*initialNonlinearity=10^5,*)
(*ts,t,interactionStrength0,soundSpeed0,*)
(*pp,fig*)
(*},*)
(*(*time scale in terms of nondimensionalized time scale*)*)
(*ts=nonDimTimeScale (m boxLength^2)/\[HBar];*)
(*(*Nondimensionalized lab time in terms of expansion.  Effectively just t = tf for a given expansion.*)*)
(*t=(\[HBar]/(m boxLength^2))Normal@First@SolveValues[expansion[2,ts][tf]==2000&&tf>0&&ts>0,tf];*)
(*interactionStrength0=initialNonlinearity \[HBar]^2/(n0 m boxLength^2);*)
(*soundSpeed0=Sqrt@initialNonlinearity;*)
(**)
(*pp=particleProduction[n0,ts][t,k boxLength]/.{interactionStrength[0]->interactionStrength0,soundSpeed[0]->soundSpeed0};*)
(*fig=Function[k,Evaluate@pp];*)
(*DiscretePlot[*)
(*fig@momentumMagnitude/.nonDimTimeScale->nonDimTimeScaleList//Evaluate,*)
(*{momentumMagnitude,0,200},*)
(*AxesOrigin->{0,0},*)
(*Filling->None,*)
(*Joined->True,*)
(*AxesLabel->{ToString[Abs[k]L,TraditionalForm],"\!\(\*SubscriptBox[\(N\), \(k\)]\)"},*)
(*PlotLegends->("\!\(\*SubscriptBox[OverscriptBox[\(t\), \(_\)], \(s\)]\) = "<>ToString[ScientificForm@#,TraditionalForm]&)/@nonDimTimeScaleList*)
(*]*)
(*]//Rasterize[#,ImageSize->72 12,ImageResolution->300]&*)


(* ::Input:: *)
(*Export[FileNameJoin@{NotebookDirectory[],"results","fig2.png"},fig2]*)
