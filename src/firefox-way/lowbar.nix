{
    e = builtins.elemAt;
    select = builtins.foldl' (l: r: l.${r});

    formatDate = delim: d: with builtins; foldl' (l: r: "${l}${delim}${r}") (head d) (tail d);
}
