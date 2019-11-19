So this isn't something I have actually scripted but we can see how it goes.

Basically through the dashboard we can see when Depositors differ at each ACE 
AM, but not what collections or files within those collection differ. The
workflow for finding this out is to use the `Status` json endpoint, querying on
only the depositor in question. From here the `totalFiles` can be grepped out
of the json and passed to diff.

Tools like `jq` could probably be used, but I do not have it installed so just
making do without.
