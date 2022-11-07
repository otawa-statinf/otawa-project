# otawa-project
Meta-repository of the OTAWA project. Fork of https://sourcesup.renater.fr/projects/otawa/.

For documentation, see https://www.tracesgroup.net/otawa/. In particular, from [this page](https://www.tracesgroup.net/otawa/?page_id=419):

> OTAWA v2 is embedding a new installation that supports OTAWA installation and third-party plug-in installation from web repository, called `otawa-install.py`. Note `otawa-install.py` should only work only for Linux but we hope to quickly adapt it to Mac and Windows.
> 
> Before running `otawa-install.py`, the following dependencies must/may be available:
> 
> - Python 3 (required)
> - GNU C++ (required)
> - OCaml (required)
> - Flex, Bison (required)
> - libxml2-dev, libxslt1-dev (required)
> - cmake, git (required)
> - GraphViz (for graph output)
> 
> Using `otawa-install.py` is relatively easy. First download it in the directory that will contain the installation of OTAWA (say, `OTAWA_HOME`).
> 
>     $ cd OTAWA_HOME
>     $ ./otawa-install.py
>     The packages will be installed in /home/casse/tmp/otawa: [yes/NO]: yes
> 
> This will take a while to install the minimum set of libraries and tools for OTAWA. Be patient…
> 
> After that, recall to use the otawa-install.py command in OTAWA_HOME/bin/otawa-install.py to install some plug-in.
> 
> To get the list of plugins, just type:
> 
> ```
> OTAWA_HOME/bin/otawa-install.py -l
> ```
> 
> Note that OTAWA is first delivered alone (no instruction set, no micro-architecture except trivial ones, no ILP solver). You have to use `otawa-install.py` to install them.
