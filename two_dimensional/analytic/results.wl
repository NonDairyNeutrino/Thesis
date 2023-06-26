(* ::Package:: *)

(* ::Section:: *)
(*Results*)


(* ::Subsection:: *)
(*Definitions*)


(* ::Input:: *)
(*SetOptions[ListLinePlot3D,{AxesLabel->(Style[#,Black,12]&/@{"|k|","t \[Times] \!\(\*SuperscriptBox[\(10\), \(-4\)]\)","\!\(\*SubscriptBox[\(N\), \(k\)]\)"}),PlotRange->All}];*)


(* ::Input:: *)
(*Clear@nonDimTimeScaleList*)
(*nonDimTimeScaleList=N@{1 10^-5,2 10^-5,5 10^-5,1 10^-4,1 10^-3};*)


Clear@pp
pp[nonDimTimeScale_][k_,t_]=Block[
{boxLength=1,
m=1,
\[HBar]=1,
n0=10^7,
initialNonlinearity=10^5,
expansionValue=2000,
ts,tf,
interactionStrength0,soundSpeed0,pp,data
},
(*time scale in terms of nondimensionalized time scale*)
ts=nonDimTimeScale (m boxLength^2)/\[HBar];
interactionStrength0=initialNonlinearity \[HBar]^2/(n0 m boxLength^2);
soundSpeed0=Sqrt@initialNonlinearity;
tf=Normal@First@SolveValues[expansion[2,ts][tf]==expansionValue&&tf>0&&ts>0,tf];
particleProduction[n0,ts][(\[HBar]/(m boxLength^2))t,k boxLength]/.{interactionStrength[0]->interactionStrength0,soundSpeed[0]->soundSpeed0}//N
]


(* ::Input:: *)
(*pp[10^-5][1,Subdivide[0.,10^-4,1000]]//Chop*)


(* ::Subsection::Closed:: *)
(*Single Time Scale*)


(* ::Input:: *)
(*DiscretePlot[*)
(*pp[ts][momentumMagnitude,tf]//.{tf->Normal@First@SolveValues[expansion[2,ts][tf]==2000&&tf>0&&ts>0,tf],ts->5 10^-5}//Evaluate,*)
(*{momentumMagnitude,0,200},*)
(*AxesOrigin->{0,0},*)
(*Filling->None,*)
(*Joined->True,*)
(*AxesLabel->{ToString[Abs[k]L,TraditionalForm],"\!\(\*SubscriptBox[\(N\), \(k\)]\)"}*)
(*]*)


(* ::Subsection::Closed:: *)
(*Multiple Time Scales*)


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
(*(*Export[FileNameJoin@{NotebookDirectory[],"results","fig2.png"},fig2]*)*)


(* ::Subsection::Closed:: *)
(*Single Time Scale and Multiple Times*)


(* ::Input:: *)
(*Clear@data*)
(*data=Block[*)
(*{boxLength=1,*)
(*m=1,*)
(*\[HBar]=1,*)
(*n0=10^7,*)
(*initialNonlinearity=10^5,*)
(*nonDimTimeScale=10^-4,*)
(*expansionValue=2000,*)
(*ts,tf,*)
(*interactionStrength0,soundSpeed0,pp,data*)
(*},*)
(*(*time scale in terms of nondimensionalized time scale*)*)
(*ts=nonDimTimeScale (m boxLength^2)/\[HBar];*)
(*interactionStrength0=initialNonlinearity \[HBar]^2/(n0 m boxLength^2);*)
(*soundSpeed0=Sqrt@initialNonlinearity;*)
(*tf=Normal@First@SolveValues[expansion[2,ts][tf]==expansionValue&&tf>0&&ts>0,tf];*)
(**)
(*pp=particleProduction[n0,ts][(\[HBar]/(m boxLength^2))t,k boxLength]/.{interactionStrength[0]->interactionStrength0,soundSpeed[0]->soundSpeed0};*)
(*data=(*Catenate@*)ParallelTable[{k,t 10^4,Evaluate@pp},{k,1.,201,5},{t,0.,tf,tf/50}]//Chop*)
(*];*)


(* ::Input:: *)
(*Show[*)
(*ListLinePlot3D[*)
(*data,*)
(*AxesLabel->(Style[#,Black,12]&/@{"|k|","t \[Times] \!\(\*SuperscriptBox[\(10\), \(-4\)]\)","\!\(\*SubscriptBox[\(N\), \(k\)]\)"}),*)
(*PlotRange->All,*)
(*PlotStyle->ColorData[1][1]*)
(*],*)
(*ListLinePlot3D[*)
(*data[[;;,-1]],*)
(*AxesLabel->(Style[#,Black,12]&/@{"|k|","t \[Times] \!\(\*SuperscriptBox[\(10\), \(-4\)]\)","\!\(\*SubscriptBox[\(N\), \(k\)]\)"}),*)
(*PlotRange->All,*)
(*PlotStyle->{Darker[Green,2/5],Thickness[.01]}*)
(*]*)
(*]*)


(* ::Subsection:: *)
(*Multiple Time Scales and Multiple Times*)


(* ::Input:: *)
(*Clear@data*)
(*data=Block[*)
(*{boxLength=1,*)
(*m=1,*)
(*\[HBar]=1,*)
(*n0=10^7,*)
(*initialNonlinearity=10^5,*)
(*expansionValue=2000,*)
(*ts,tf,*)
(*interactionStrength0,soundSpeed0,pp,data*)
(*},*)
(*(*time scale in terms of nondimensionalized time scale*)*)
(*ts=nonDimTimeScale (m boxLength^2)/\[HBar];*)
(*interactionStrength0=initialNonlinearity \[HBar]^2/(n0 m boxLength^2);*)
(*soundSpeed0=Sqrt@initialNonlinearity;*)
(*tf=Normal@First@SolveValues[expansion[2,ts][tf]==expansionValue&&tf>0&&ts>0,tf];*)
(**)
(*pp=particleProduction[n0,ts][(\[HBar]/(m boxLength^2))t,k boxLength]/.{interactionStrength[0]->interactionStrength0,soundSpeed[0]->soundSpeed0};*)
(*data=(*Catenate@*)ParallelTable[{k,t 10^4,Evaluate@pp},{nonDimTimeScale,nonDimTimeScaleList},{k,1.,201,5},{t,0.,tf,tf/50}]//Chop*)
(*];*)


(* ::Input:: *)
(*MapThread[*)
(*Show[*)
(*ListLinePlot3D[*)
(*#1,*)
(*PlotStyle->ColorData[1][1]*)
(*],*)
(*ListLinePlot3D[*)
(*#1[[;;,-1]],*)
(*PlotStyle->{Darker[Green,2/5],Thickness[.01]}*)
(*],*)
(*PlotLabel->Style["\!\(\*SubscriptBox[OverscriptBox[\(t\), \(_\)], \(s\)]\) = "<>ToString[ScientificForm@#2,TraditionalForm]<>"\n",Black],*)
(*FaceGrids->{{-1,0,0},{0,1,0}},*)
(*FaceGridsStyle->Directive[Black,Dashed]*)
(*]&,*)
(*{data,nonDimTimeScaleList}*)
(*]//GraphicsGrid[Partition[#[[{1,3,4,5}]],2],ImageSize->72*12,ImageMargins->10]&//Rasterize[#,ImageSize->72 12,ImageResolution->300]&*)
(*(*Export[FileNameJoin@{NotebookDirectory[],"results","Analytic_Fig_4.png"},%]//SystemOpen*)*)
