with import ./lowbar.nix;

rec {
    selectDate = select (import ./daily.nix);
    getDailyByI = date: key: i: let
        curDaily = (selectDate date).${key};
    in (
        if i < builtins.length curDaily
        then {just = e curDaily i;}
        else {nothing = true;}
    );
    getDailySet = date: key: {
        rev = (getDailyByI date key 0).just;
        sha256 = (getDailyByI date key 1).just or "SKIP";
    };
}
