import Array "mo:base/Array";
import Float "mo:base/Float";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
actor {
    public type Pixel = Nat8;

    public type Map = [var Pixel];
    public type FrozenMap = [Pixel];

    public type Color = (Nat8, Nat8, Nat8);

    let SIZE = 1000;
    let TOTAL_LENGTH = SIZE * SIZE * 3;

    let ROW_SIZE = SIZE * 3;

    let UNIT_SHIFT = 10; // pixelPrice 1; UNIT_SHIFT 10; pixelPrice = 10; or 10 cents
    let PIXEL_PRICE = 1*UNIT_SHIFT;
    let CYCLE_PER_USD = 1000000000000*UNIT_SHIFT;

    var frozenMap : FrozenMap = [];

    var map : Map = do {
        let white : Pixel = 0;

        Array.init<Pixel>(TOTAL_LENGTH, white);
    };

    func freezeMap() : () {
        frozenMap := Array.freeze(map);
    };

    var init = do {
        freezeMap();
    };

    public query func getMap() : async [Pixel] {
        frozenMap;        
    };

    func transformTwoDTooOneD(x : Nat, y : Nat) : Nat {
        (x + SIZE * y) * 3;
    };

    public query func transform(x : Nat, y : Nat) : async Nat {
        transformTwoDTooOneD(x, y);
    };

    public func purchasePixel(x : Nat, y : Nat, color : Color) : async () {
        let startIdx = transformTwoDTooOneD(x, y);
        let (r, g, b) = color;
        map[startIdx + 0] := r;
        map[startIdx + 1] := g;
        map[startIdx + 2] := b;
        freezeMap();
    };
};
