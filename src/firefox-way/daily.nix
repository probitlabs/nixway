let
    nightlyExpr = [
        "7081bacc88037d9e218f62767892102c96b0a321"
        "0dzqmbwl2fkrdhj3vqczk7fqah8q7mfn40wx9vqavcgcsss63m8p"
    ];
in {
    "2018"."01"."03" = {
    	stransky = [
	    "2b40d3260ae9e3f6f482db6c544329be1c343877"
	];
	rustc = [
	    ["2018" "01" "06"]
	];
	cargo = [
	    ["2018" "01" "06"]
	];
        inherit nightlyExpr;
    };
}
