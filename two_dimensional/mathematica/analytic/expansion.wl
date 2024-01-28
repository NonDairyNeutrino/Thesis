(* ::Package:: *)

(* ::Section:: *)
(*Expansion Region*)


(* ::Subsection:: *)
(*Expansion Scaling Function*)


(* ::Text:: *)
(*We define the scaling function for a de Sitter expansion and the induced conformal time.*)


Clear[scaling,conformalTime]
(*eq 100 b[t]*)scaling["Lab",timeScale_][labTime_]:=Exp[-labTime/timeScale]
(*eq 44, \[Eta]*)conformalTime[timeScale_][labTime_]=DSolveValue[
{
conformalTime[timeScale]'[labTime]==Sqrt@scaling["Lab",timeScale][labTime],
conformalTime[timeScale][0]==-2 timeScale(*expansion dependent*)
},
conformalTime[timeScale][labTime],
labTime
];
(*eq 102 b[\[Eta]]*)scaling["Conformal",timeScale_][\[Eta]_]=With[
(*First get the lab time in terms of the conformal time*)
{conformalTime=First@Normal@SolveValues[conformalTime[timeScale][labTime]==\[Eta],labTime]},
scaling["Lab",timeScale][conformalTime]
];


Clear@labToConformal
labToConformal=Solve[conformalTime[timeScale][labTime]==\[Eta],labTime][[1,1]]//Normal//ReplaceAll;


(* ::Subsection:: *)
(*Expansion Mode Solutions/Fourier Amplitudes*)


(* ::Subsubsection:: *)
(*Phase Field Equation and Boundary Conditions*)


(* ::Text:: *)
(*The calculation of particle production requires the solution of the phase field equation (eq 46) for its Fourier amplitudes (as defined in eq 36).*)


(* ::Text:: *)
(*Because we can get the density Fourier amplitude from the phase Fourier amplitude (eq 81), we find the latter from solving the phase-field equation (eq 46) after substituting with phase-field the Fourier expansion (eq 36).  The specifics of the combination of the field equation and the Fourier expansion to yield the form shown (eq 103) still need to be detailed.*)


Clear@fieldEquation
(*eq103*)fieldEquation=\[Chi][waveNumber]''[\[Eta]]-\[Chi][waveNumber]'[\[Eta]]/\[Eta]+c[0]^2 waveNumber^2 \[Chi][waveNumber][\[Eta]]==0;


(* ::Text:: *)
(*The boundary conditions to our field equation are such that the phase and density Fourier amplitudes in the in region (i.e. before the expansion) are equal to their counterpart in the expansion region at the t = 0 transition point.*)


Clear@boundaryConditions
boundaryConditions=Splice@{
(*phase field equivalence at t = 0 region transition*)
phaseFourierAmplitude["out",timeScale][labTime,waveNumber]==\[Chi][waveNumber][conformalTime[timeScale][labTime]]/.labTime->0,
(*density field equivalence at t = 0 region transition*)
densityFourierAmplitude["out",timeScale][labTime,waveNumber]==-(\[HBar]/interactionStrength[timeScale][labTime]) D[#,labTime]&[
\[Chi][waveNumber][conformalTime[timeScale][labTime]]
]/.labTime->0
};


(* ::Subsubsection:: *)
(*Phase Field Solution & Density Amplitude*)


(* ::Text:: *)
(*After solving the field equation and getting the density Fourier amplitude, we transform the rather messy expressions to one that is more easily compared to the result in the literature.*)


(*eq 104, \[Chi]*)phaseFourierAmplitude["exp",timeScale_][labTime_,waveNumber_]=DSolveValue[
{fieldEquation,boundaryConditions},
\[Chi][waveNumber][\[Eta]],\[Eta]
]/.{
\[Eta]->conformalTime[timeScale][labTime],
k->waveNumber,
c[0]->dispersion[timeScale][0,waveNumber]/waveNumber
};


(* ::Input:: *)
(*(*show in terms of conformal time*)*)
(*Subscript[\[Chi], k][t]==(%//labToConformal//FullSimplify//Collect[#,{(BesselJ|BesselY)[1,Times[___,\[Eta],___]],\[Eta]},Simplify]&)//notate*)


(*eq 81, n*)densityFourierAmplitude["exp",timeScale_][labTime_,waveNumber_]=-(\[HBar]/interactionStrength[timeScale][labTime]) D[#,labTime]&@phaseFourierAmplitude["exp",timeScale][labTime,waveNumber]//FullSimplify;


(* ::Input:: *)
(*(*show in terms of conformal time*)*)
(*Subscript[n, k][t]==(%//labToConformal//FullSimplify//Collect[#,{(BesselJ|BesselY)[0,Times[___,\[Eta],___]],\[Eta]},Simplify]&)//notate*)
