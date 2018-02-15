pkgs:

{
    src = pkgs.fetchFromGitHub {
    	owner = "Igalia";
	repo = "chromium";
        rev = "84815d6e1d4fc8e7d82ec5113af057a170304e4d";
        # ↑ Jan '18
        sha256 = "0mz93id62sbg8xbwfvcp6vrc02bb209qg49yxhzw9kh5871s0lf1";
    };
}
