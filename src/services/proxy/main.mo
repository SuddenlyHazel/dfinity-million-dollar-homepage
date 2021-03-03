import Array "mo:base/Array";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Float "mo:base/Float";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Types "../types";

actor {
    var someMap : ?Types.PixelCanister = null;

    public func setMapCanister(principal : Principal) : async () {
        someMap := ?(actor(Principal.toText(principal)));
    };

    var lastBalance = ExperimentalCycles.balance();

    public func purchasePixels(pixels : [{x : Nat; y : Nat; color : Types.Color}], sendAmount : Nat) : async Result.Result<(), Text> {
        switch(someMap) {
            case(null) {#err("Need to install a map canister first")};
            case(?v) {
                ExperimentalCycles.add(sendAmount);
                return await v.purchasePixels(pixels);
            };
        }
    };

    public func purchasePixel(x : Nat, y : Nat, color : Types.Color, sendAmount : Nat) : async Result.Result<(), Text> {
        switch(someMap) {
            case(null) {#err("Need to install a map canister first")};
            case(?v) {
                ExperimentalCycles.add(sendAmount);
                return await v.purchasePixel(x, y, color);
            };
        }
    };

    public func getBalance() : async {now : Nat; last : Nat; change : Float} {
        let balanceNow = ExperimentalCycles.balance();
        let p = {
            now = balanceNow;
            last = lastBalance;
            change = Float.fromInt(balanceNow) - Float.fromInt(lastBalance);
        };
        lastBalance := balanceNow;
        return p;
    }
};
