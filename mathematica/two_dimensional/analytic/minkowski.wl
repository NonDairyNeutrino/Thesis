(* ::Package:: *)

(* ::Section:: *)
(*Minkowski In/Out Region*)


(* ::Text:: *)
(*Note: These representations are only valid for regions of spacetime outside of the expansion, where the spacetime is Minkowski flat.  In other words, before of after the expansion has happened.*)


(* ::Subsection:: *)
(*Minkowski Field Modes/Fourier Amplitudes*)


(* ::Text:: *)
(*The phase and density in the Madelung representation of the particle field can be Fourier expanded with the following amplitudes.  In other words, the phase and density of the particle field can be represented via the inverse discrete Fourier transform with the following amplitudes.*)


Clear[phaseFourierAmplitude,densityFourierAmplitude]
(*eq 82*)phaseFourierAmplitude["out",timeScale_][labTime_,waveNumber_]:=With[
{dispersion=dispersion[timeScale][labTime,waveNumber]},
Sqrt[interactionStrength[labTime]/(2\[HBar] dispersion)]Exp[-I dispersion labTime]
]
(*eq 83*)densityFourierAmplitude["out",timeScale_][labTime_,waveNumber_]:=With[
{dispersion=dispersion[timeScale][labTime,waveNumber]},
I Sqrt[\[HBar] dispersion/(2interactionStrength[labTime])]Exp[-I dispersion labTime]
]


(* ::Subsection:: *)
(*Minkowski "Mixed" Field Modes/Fourier Amplitudes*)


(* ::Text:: *)
(*The density and phase fields (not modes) can be represented in the same basis by mixing the field modes (yes modes).*)


Clear@mixedFourierAmplitude
(*eq 74 and 75*)mixedFourierAmplitude[operation:(Plus|Subtract)][
initialDensity_,
densityFourierAmplitude_(*function of time*),
phaseFourierAmplitude_(*function of time*)
]:=operation[
densityFourierAmplitude/(2Sqrt@initialDensity),
 I Sqrt[initialDensity]phaseFourierAmplitude
]
(*Usage of Plus corresponds to the u mixed mode, and Subtract corresponds to the v mixed mode.*)
(*The Subtract version of the mixedFourierMode does not equal the conjugate of the Plus version because the field modes themsevles are complex*)


(* ::Text:: *)
(*We can then describe the mixed Fourier modes after the expansion i.e. in the "out" region of cosmology.*)


(*comment from eq 87*)
mixedFourierAmplitude["out"][Plus]=.//Quiet;
mixedFourierAmplitude["out"][Plus][initialDensity_,timeScale_][labTime_,waveNumber_]:=mixedFourierAmplitude[Plus][
initialDensity,
densityFourierAmplitude["out",timeScale][labTime,waveNumber],
phaseFourierAmplitude["out",timeScale][labTime,waveNumber]
]
mixedFourierAmplitude["out"][Subtract]=.//Quiet;
mixedFourierAmplitude["out"][Subtract][initialDensity_,timeScale_][labTime_,waveNumber_]:=mixedFourierAmplitude[Subtract][
initialDensity,
densityFourierAmplitude["out",timeScale][labTime,waveNumber],
phaseFourierAmplitude["out",timeScale][labTime,waveNumber]
]
