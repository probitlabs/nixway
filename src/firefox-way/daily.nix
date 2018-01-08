let
    nightlyExpr = ["7081bacc88037d9e218f62767892102c96b0a321"];
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
