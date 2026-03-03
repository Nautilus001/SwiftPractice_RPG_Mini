import Foundation

enum Race {
    case human, elf, dwarf, orc
    
    var defaultVoiceline: String {
        switch self{
        case .human: return "Huzzah"
        case .elf: return "Verily"
        case .dwarf: return "Harrumph"
        case .orc: return "GrrrrRRRRAAAAAAAAA!!"
        }
    }
}

protocol Entity {
    var name: String {get set}
}

protocol SentientEntity: Entity {
    var race: Race {get set}
    func speak() -> String
}

extension SentientEntity {
    func speak() -> String {
        return race.defaultVoiceline
    }
}

protocol Combatant {
    var hp: Int {get set}
    var atk: Int {get set}
    var isAlive: Bool {get}
    mutating func takeDamage(_ damage: Int)
}

extension Combatant {
    var isAlive: Bool {
        return hp > 0
    }
    mutating func takeDamage (_ damage: Int) {
        hp -= damage
    }
}

protocol PlayerCharacter {
    var customVoiceline: String? {set get}
}

struct PC: PlayerCharacter, SentientEntity, Combatant{
    var name: String
    var race: Race
    var customVoiceline: String?
    var hp: Int
    var atk: Int
    
    func speak() -> String {
        customVoiceline ?? race.defaultVoiceline
    }
}

struct Enemy: SentientEntity, Combatant {
    var name: String
    var race: Race
    var hp: Int
    var atk: Int
    
    func speak() -> String {
        race.defaultVoiceline
    }
}

print("COMP: Hello! Welcome to this game!")
print("COMP: First off, introductions! I know who I am, but WHO are YOU?!")
print("You: ", terminator: "")

let name = readLine() ?? "Anonymous"

print("COMP: Nice to meet you, \(name)!")

print("Please, select a race: Human, Elf, Dwarf or Orc: ")

var playerRace: Race
let race = readLine() ?? ""

switch race.lowercased() {
case "elf": playerRace = .elf
case "human": playerRace = .human
case "dwarf": playerRace = .dwarf
case "orc": playerRace = .orc
default: playerRace = .human; print("Thats... unintelligible. Very human of you!")
}



print("COMP: Oh, by the way, you know that thing you say so frequently that people around you have started to roll their eyes a little when you say it? \n Tell me what it is (or just press ENTER if you are a coward)")

let voiceline = readLine() ?? playerRace.defaultVoiceline

var player: PC = PC(name: name, race: playerRace, hp: 10, atk: 10)
var enemy1: Enemy = Enemy(name: "Gorlog the Destroyer", race: .orc, hp: 90, atk: 1)

print ("COMP: Howdy \(player.name), glad to make your acquaintance.")

print ("\(enemy1.name.uppercased()): \(enemy1.speak())")
print ("COMP: Huh... to me, that seems like a YOU problem. Laters! *leaves*")

var attacker: Bool = true
while player.isAlive && enemy1.isAlive {
    if attacker {
        player.takeDamage(enemy1.atk)
        print("You are attacked by \(enemy1.name), you take \(enemy1.atk) damage!")
    } else {
        enemy1.takeDamage(player.atk)
        print("You attack \(enemy1.name), you deal \(player.atk) damage!")
    }
    
    print("YOU: [hp: \(player.hp), atk: \(player.atk)] | \(enemy1.name.uppercased()): [hp: \(enemy1.hp), atk: \(enemy1.atk)]")
    Thread.sleep(forTimeInterval: 2.0)
    attacker.toggle()

}

if (player.isAlive) {
    print("COMP: I knew you'd emerge victorious! Welp, you've got it from here, good luck!")
} else {
    print ("YOU DIE AND ARE SUBSEQUENTLY EATEN!")
    Thread.sleep(forTimeInterval: 1.0)
    print ("COMP: See \(enemy1.name), I can get you many MANY more players to eat! Just don't eat ME!!")
}

