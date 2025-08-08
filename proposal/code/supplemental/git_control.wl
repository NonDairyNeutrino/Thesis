(* ::Package:: *)

Needs["Wolfram`GitLink`"]
repo = GitOpen@Echo[ParentDirectory@NotebookDirectory[],"Repo Directory"];
Print@Column@{"initial git status: ", Dataset@GitStatus@repo}
ButtonBar[
  {
    "git status" :> Print@GitStatus@repo,
    "git add [THIS NOTEBOOK]" :> GitAdd@NotebookFileName[],
    "git reset" :> GitReset@NotebookFileName[],
    "git commit -m" :> GitCommit[repo, InputString["Commit message"]]
    (*Git push is not included here because of fundamental issues with the GitLink package. See https://github.com/WolframResearch/GitLink/issues*)
  },
  BaseStyle -> 15,
  FrameMargins -> Medium,
  Appearance -> "Vertical",
  Method -> "Queued"
]
