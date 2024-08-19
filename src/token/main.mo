import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";

actor Token{
    var owner : Principal = Principal.fromText("57gm2-homr6-nap42-moiup-yf7yh-tww7l-6fqp3-so3wr-voyjn-ktcua-aae");
    var totalSupply : Nat = 1000000000;
    var symbol : Text = "DANG";

    var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    balances.put(owner, totalSupply);

    public query func balanceOf(who : Principal) : async Nat {
        let balance : Nat = switch (balances.get(who)){
            case null 0;
            case (?result) result;
        };
        return balance;
    };

    public query func getTokenSymbol() : async Text{
        return symbol;
    };

    public shared(msg) func payOut() : async Text{
        //Debug.print(debug_show(msg.caller));
        if(balances.get(msg.caller) == null){
            let amount = 10000;
            balances.put(msg.caller, amount);
            return "Success";
        } else{
            return "Already Claimed";
        }
        
    };

    public shared(msg) func transfer(to: Principal, amount : Nat) : async Text{
        let fromBalance = await balanceOf(msg.caller);
        if(fromBalance > amount){
            let newFromBalance : Nat = fromBalance - amount;
            balances.put(msg.caller, newFromBalance);
            
            let toBalance = await balanceOf(to);
            let newToBalance = toBalance + amount;

            balances.put(to, newToBalance);

            return "Success";
        }
        else{
            return "Insufficient funds";
        }
    }
}