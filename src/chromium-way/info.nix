pkgs:

{
    src = fetchFromGitHub {
    	owner = "Igalia";
	repo = "chromium";
	rev = "84815d6e1d4fc8e7d82ec5113af057a170304e4d";
    };
}
