{
    ghFetch = pkgs.fetchFromGithub;
    e = builtins.elemAt;
  
    select = builtins.foldl' l: r: l.${r};

    formatDate = delim: d: with builtins; foldl' (f: l: "${l}${delim}${r}") (head d) (tail d);
};
