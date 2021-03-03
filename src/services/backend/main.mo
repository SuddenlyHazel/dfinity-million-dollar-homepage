import Array "mo:base/Array";
import Debug "mo:base/Debug";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Float "mo:base/Float";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Random "mo:base/Random";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Types "../types";

actor {

    let SIZE = 1000;
    let TOTAL_LENGTH = SIZE * SIZE * 3;

    let ROW_SIZE = SIZE * 3;

    let PIXEL_PRICE = 1000000000000 / 10; 


    var frozenMap : Types.FrozenMap = [];
    var lastBalance = ExperimentalCycles.balance();

    var map : Types.Map = do {
        let white : Types.Pixel = 0;

        Array.init<Types.Pixel>(TOTAL_LENGTH, white);
    };

    func freezeMap() : () {
        frozenMap := Array.freeze(map);
    };

    var init = do {
        freezeMap();
    };

    public query func getMap() : async [Types.Pixel] {
        frozenMap;        
    };

    func transformTwoDTooOneD(x : Nat, y : Nat) : Nat {
        (x + SIZE * y) * 3;
    };

    public query func transform(x : Nat, y : Nat) : async Nat {
        transformTwoDTooOneD(x, y);
    };

    public func purchasePixels(pixels : [{x : Nat; y : Nat; color : Types.Color}]) : async Result.Result<(), Text> {
        let sent = ExperimentalCycles.available();
        let needed = pixels.size() * PIXEL_PRICE;

        if (needed != sent) {
            return #err("User sent " # Nat.toText(sent) # " but required " # Nat.toText(needed));
        };
        let _ = ExperimentalCycles.accept(sent);
        #ok();
    };

    public func purchasePixel(x : Nat, y : Nat, color : Types.Color) : async Result.Result<(), Text> {
        let start = ExperimentalCycles.balance();
        let sent = ExperimentalCycles.available();

        let startIdx = transformTwoDTooOneD(x, y);
        let (r, g, b) = color;
        map[startIdx + 0] := r;
        map[startIdx + 1] := g;
        map[startIdx + 2] := b;
        freezeMap();
        Debug.print("Start balance " # Nat.toText(start) # " Balance after " # Nat.toText(ExperimentalCycles.balance()));
        //let actual = ExperimentalCycles.accept(sent);
        //Debug.print("Actual " # Nat.toText(actual));
        #ok();
    };

    public func getBalance() : async {value : Float; change : Float} {
        let balanceNow = ExperimentalCycles.balance();
        let p = {
            value = Float.fromInt(balanceNow) / 1000000000000.0;
            change = (Float.fromInt(balanceNow) - Float.fromInt(lastBalance)) / 1000000000000.0
        };
        lastBalance := balanceNow;
        return p;
    };

    public func burnCycles(v : Nat) : async () {
        var a : [Nat] = [];
        while (a.size() < v) {
            a := Array.append(a, [v]);
        };
    }
};
