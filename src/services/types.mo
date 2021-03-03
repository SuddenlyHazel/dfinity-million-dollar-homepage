import Result "mo:base/Result";
module {
    public type Pixel = Nat8;

    public type Map = [var Pixel];
    public type FrozenMap = [Pixel];

    public type Color = (Nat8, Nat8, Nat8);


    public type PixelCanister = actor {
        purchasePixels : shared  (pixels : [{x : Nat; y : Nat; color : Color}]) -> async Result.Result<(), Text>;
        purchasePixel : shared  (x : Nat, y : Nat, color : Color) -> async Result.Result<(), Text>;
    };
};
