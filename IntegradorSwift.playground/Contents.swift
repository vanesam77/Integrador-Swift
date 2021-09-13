import Foundation
import UIKit

protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get }
    var parkedTime: Int { get }

    
    func calculateFeeOf(_ vehicleType: VehicleType, parkedTime: Int, hasDiscountCard: Bool) -> Int
    
}

//Se define vehicles como Set porque no pueden haber dos autos iguales
struct Parking {
    var vehicles: Set<Vehicle> = []
    let maxVehicle: Int = 20
    var countOfVehicleHaveCheckedOut = 0
    var listOfVehiclesPlates: Set<String> = []
    
    mutating func listVehicles(){
        for vehicle in vehicles{
            let vehiclePlate:String = vehicle.plate
            listOfVehiclesPlates.insert(vehiclePlate)
            print("Vehicle's plate:  \(vehicle.plate)")
        }
    }
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        
        //VALIDAR la cantidad maxima de autos
        guard (maxVehicle > vehicles.count) else {
            print("Sorry, the check-in failed. The Parking is full")
            onFinish.self(false)
            return
        }
        
        //VALIDAR que no coincida la patente que quiero agregar con la que ya tengo
        let plateToAdd = vehicle.plate
        if listOfVehiclesPlates.contains(plateToAdd) {
            print("Sorry, the check-in failed. The plate: \(plateToAdd) has already exist")
            onFinish.self(false)
        } else {
            vehicles.insert(vehicle)
            listOfVehiclesPlates.insert(plateToAdd)
            onFinish.self(true)
            print("Welcome to AlkeParking!")
        }
        
    }
    
    mutating func checkOutVehicle(_ plate: String, onSucces: (Int) -> Void, onError: (Bool) -> Void) {
        
        guard listOfVehiclesPlates.contains(plate) else {
            print("Sorry, the check-out failed. Plate \(plate) not found")
            onError.self(true)
            return
        }
        
        for vehicle in vehicles {
            if vehicle.plate == plate{
                let vehicleToRemove = vehicle
                let parkedTime: Int = vehicleToRemove.parkedTime
                
                
                vehicles.remove(vehicleToRemove)
                listOfVehiclesPlates.remove(plate)
                countOfVehicleHaveCheckedOut += 1
                onSucces.self(parkedTime)
                print("Succes check out")
            }
        }
    }
    
}


struct Vehicle: Parkable, Hashable {
    
    let plate: String
    let type: VehicleType
    var checkInTime: Date
    var parkedTime: Int {
        get {
            return Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
        }
    }
    let discountCard: String?
    

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
    

    
    func calculateFeeOf(_ vehicleType: VehicleType, parkedTime: Int, hasDiscountCard: Bool) -> Int{
        var fee: Int = 0
        let fee2hsParking = vehicleType.parkingRate
        
        if parkedTime > 120 {
            let parkingTimeExceeded = Int(((abs(Double(parkedTime) - 120.0))/15).rounded(.up))*5
            
            fee = fee2hsParking + parkingTimeExceeded
        } else {
            fee = fee2hsParking
        }
        
        if hasDiscountCard == true {
            let discount = Int((fee*15)/100)
            fee = fee - discount
        }
        
        print("Your fee is $ \(fee). Come back soon")
        return fee
    }
}


enum VehicleType {
    case car, moto,miniBus,bus
    
    var parkingRate: Int {
        switch self {
        case .car:
            return 20
        case .moto:
            return 15
        case .miniBus:
            return 25
        case .bus:
            return 30
        }
    }
}


//instancias

var alkeParking = Parking()

let vehicle1 = Vehicle(plate: "AA111AA", type:VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let vehicle2 = Vehicle(plate: "B222BBB", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle3 = Vehicle(plate: "CC333CC", type:VehicleType.miniBus, checkInTime: Date(), discountCard:
                        nil)
let vehicle4 = Vehicle(plate: "DD444DD", type:VehicleType.bus, checkInTime: Date(), discountCard:
                        "DISCOUNT_CARD_002")
let vehicle5 = Vehicle(plate: "AA111BB", type:VehicleType.car, checkInTime: Date(), discountCard:
                        "DISCOUNT_CARD_003")
let vehicle6 = Vehicle(plate: "B222CCC", type:VehicleType.moto, checkInTime: Date(), discountCard:
                        "DISCOUNT_CARD_004")
let vehicle7 = Vehicle(plate: "CC333DD", type:VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle8 = Vehicle(plate: "DD444EE", type:VehicleType.bus, checkInTime: Date(), discountCard:
                        "DISCOUNT_CARD_005")
let vehicle9 = Vehicle(plate: "AA111CC", type:VehicleType.car, checkInTime: Date(), discountCard: nil)
let vehicle10 = Vehicle(plate: "B222DDD", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle11 = Vehicle(plate: "CC333EE", type:VehicleType.miniBus, checkInTime: Date(), discountCard:
                            nil)
let vehicle12 = Vehicle(plate: "DD444GG", type:VehicleType.bus, checkInTime: Date(), discountCard:
                            "DISCOUNT_CARD_006")
let vehicle13 = Vehicle(plate: "AA111DD", type:VehicleType.car, checkInTime: Date(), discountCard:
                            "DISCOUNT_CARD_007")
let vehicle14 = Vehicle(plate: "B222EEE", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle15 = Vehicle(plate: "CC333FF", type:VehicleType.miniBus, checkInTime: Date(), discountCard:
                            nil)
let vehicle16 = Vehicle(plate: "B222DDo", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle17 = Vehicle(plate: "B222DDo", type:VehicleType.miniBus, checkInTime: Date(), discountCard:
                            nil)
let vehicle18 = Vehicle(plate: "DD444Go", type:VehicleType.bus, checkInTime: Date(), discountCard:
                            "DISCOUNT_CARD_006")
let vehicle19 = Vehicle(plate: "AA111Do", type:VehicleType.car, checkInTime: Date(), discountCard:
                            "DISCOUNT_CARD_007")
let vehicle20 = Vehicle(plate: "B222EEo", type:VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle21 = Vehicle(plate: "CC333Fo", type:VehicleType.miniBus, checkInTime: Date(), discountCard:
                            nil)
let vehicle22 = Vehicle(plate: "CC333Fo", type:VehicleType.miniBus, checkInTime: Date(), discountCard:
                            nil)

var vehiclesArray = [vehicle1, vehicle2,vehicle3,vehicle4,vehicle5,vehicle6,vehicle7,vehicle8,vehicle9,
                     vehicle10,vehicle11,vehicle12,vehicle13,vehicle14,vehicle15, vehicle16, vehicle17,vehicle18,vehicle19,vehicle20,vehicle21,vehicle22]

func AlkeCheckInListOfVehiclesARray() {
    var contador = 0
    for vehicle in vehiclesArray {
        alkeParking.checkInVehicle(vehicle) {(onFinish: Bool) -> Void in
            contador += 1
            print(" Vehicle's number: \(contador) with plate \(vehicle.plate), checkInTime \(vehicle.checkInTime) ")
            return
        }
    }
}

var earning = 0
func checkOutVehicle(vehicle: Vehicle,plate: String, parkedTime: Int, hasDiscountCardBool: Bool){
    alkeParking.checkOutVehicle(plate) { (s1: Int) in
        let fee = vehicle.calculateFeeOf(vehicle.type, parkedTime: parkedTime, hasDiscountCard: hasDiscountCardBool)
        earning = earning + fee
        return
    } onError: { (Bool) -> Void in
        return
    }
}

print("CheckIn:----------------------------------")

AlkeCheckInListOfVehiclesARray()
print("Cantidad de Autos Ingresados: \(alkeParking.vehicles.count)")
print("Patentes ingresadas: \(alkeParking.listOfVehiclesPlates)")
print("Cantidad de Patentes ingresadas: \(alkeParking.listOfVehiclesPlates.count)")

print("CheckOut:----------------------------------")


//Test Example with Error
checkOutVehicle(vehicle: vehicle18, plate: "zaraza", parkedTime: vehicle18.parkedTime, hasDiscountCardBool: (vehicle18.discountCard != nil))

print("Cantidad de Autos Ingresados: \(alkeParking.vehicles.count)")
print("Cantidad de Patentes ingresadas: \(alkeParking.listOfVehiclesPlates.count)")


//Example with Succes CheckOut

checkOutVehicle(vehicle: vehicle18, plate: vehicle18.plate, parkedTime: vehicle18.parkedTime, hasDiscountCardBool: (vehicle18.discountCard != nil))

checkOutVehicle(vehicle: vehicle19, plate: vehicle19.plate, parkedTime: vehicle19.parkedTime, hasDiscountCardBool: (vehicle19.discountCard != nil))



print("Cantidad de Autos Ingresados: \(alkeParking.vehicles.count)")
print("Cantidad de Patentes ingresadas: \(alkeParking.listOfVehiclesPlates.count)")


func AdministrateEarning(vehiclesCheckedOut:Int,earnings:Int){
    print ("\(vehiclesCheckedOut) vehicles have checked out and have earnings of $ \(earnings)")
}

var vehiclesCheckedOut = alkeParking.countOfVehicleHaveCheckedOut


AdministrateEarning(vehiclesCheckedOut: vehiclesCheckedOut, earnings: earning)














