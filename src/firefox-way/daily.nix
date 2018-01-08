let
    nightlyExpr = [
        "9e09d579431940367c1f6de9463944eef66de1d4"
        "03zkjnzd13142yla52aqmgbbnmws7q8kn1l5nqaly22j31f125xy"
    ];
in {
    "2018"."01"."02" = {
    	stransky = [
	    "2b40d3260ae9e3f6f482db6c544329be1c343877"
	];
	rust = [
	    ["2018" "01" "08"] # cargo wasn't published
	];
        inherit nightlyExpr;
    };
}
