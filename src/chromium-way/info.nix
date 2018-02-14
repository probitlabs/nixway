pkgs:

{
    src = pkgs.fetchFromGitHub {
    	owner = "Igalia";
	repo = "chromium";
        rev = "84815d6e1d4fc8e7d82ec5113af057a170304e4d";
        # ↑ Jan '18
        sha256 = "a50a5ab6d992f5598edd92105059fae9acfc192981e08bd88534c2167e92526a";
    };
}
