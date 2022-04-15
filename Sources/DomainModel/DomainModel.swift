import Foundation

struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    let amount: Int
    let currency: String?
    let acceptedCurrency = ["USD", "GBP", "EUR", "CAN"]
    
    init(amount: Int, currency: String) {
        if (amount < 0) {
            self.amount = 0
        } else {
            self.amount = amount
        }
        if acceptedCurrency.contains(currency) {
            self.currency = currency
        } else {
            print("The input currency cannot be accpeted.")
            self.currency = nil
        }
    }
    
    func convert(_ currency: String) -> Money {
        switch self.currency{
            case "USD":
                switch currency {
                    case "USD":
                        return self
                    case "GBP":
                        return Money(amount: Int(0.5 * Double(amount)), currency: "GBP")
                    case "EUR":
                        return Money(amount: Int(1.5 * Double(amount)), currency: "EUR")
                    case "CAN":
                        return Money(amount: Int(1.25 * Double(amount)), currency: "CAN")
                    default:
                        print("Illegal currency! Conversion failed!")
                        return self
                }
            case "GBP":
                switch currency {
                    case "USD":
                        return Money(amount: Int(2 * amount), currency: "USD")
                    case "GBP":
                        return self
                    case "EUR":
                        return Money(amount: 3 * amount, currency: "EUR")
                    case "CAN":
                        return Money(amount: Int(2.5 * Double(amount)), currency: "CAN")
                    default:
                        print("Illegal currency! Conversion failed!")
                        return self
                }
            case "EUR":
                switch currency {
                    case "USD":
                        return Money(amount: amount * 2 / 3, currency: "USD")
                    case "GBP":
                        return Money(amount: amount / 3, currency: "GBP")
                    case "EUR":
                        return self
                    case "CAN":
                        return Money(amount: amount * 5 / 6, currency: "CAN")
                    default:
                        print("Illegal currency! Conversion failed!")
                        return self
                }
            case "CAN":
                switch currency {
                    case "USD":
                        return Money(amount: amount * 4 / 5, currency: "USD")
                    case "GBP":
                        return Money(amount: amount * 2 / 5, currency: "GBP")
                    case "EUR":
                        return Money(amount: amount * 6 / 5, currency: "EUR")
                    case "CAN":
                        return self
                    default:
                        print("Illegal currency! Conversion failed!")
                        return self
                }
            default:
                print("Illegal currency! Conversion failed!")
                return self
        }
    }
    
    func add(_ money: Money) -> Money{
        if self.currency == money.currency {
            let totalAmount = self.amount + money.amount
            return Money(amount: totalAmount, currency: self.currency!)
        } else {
            let newMoney = self.convert(money.currency!)
            let totalAmount = newMoney.amount + money.amount
            return Money(amount: totalAmount, currency: money.currency!)
        }
    }
    
    func subtract(_ money: Money) -> Money{
        if self.currency == money.currency {
            let totalAmount = self.amount - money.amount
            return Money(amount: totalAmount, currency: self.currency!)
        } else {
            let newMoney = self.convert(money.currency!)
            let totalAmount = newMoney.amount -
            money.amount
            return Money(amount: totalAmount, currency: money.currency!)
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    let title: String
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        switch type {
            case .Hourly(let salary):
                if salary < 0 {
                    self.type = .Hourly(0)
                    print("salary cannot be negative, set to 0")
                } else {
                    self.type = type
                }
            case .Salary(_):
                self.type = type
        }
        
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    

    func calculateIncome(_ time: Int) -> Int {
        switch type {
            case .Hourly(let salary):
                return Int(salary * Double(time))
            case .Salary(let total):
                return Int(total)
        }
    }
    
    func raise(byAmount: Double) {
        switch type {
            case .Hourly(let salary):
                self.type = JobType.Hourly(salary + byAmount)
            case .Salary(let total):
                self.type = JobType.Salary(UInt(Double(total) + byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch type {
            case .Hourly(let salary):
                self.type = JobType.Hourly(salary * (1.0 + byPercent))
            case .Salary(let total):
                self.type = JobType.Salary(UInt(Double(total) * (1.0 + byPercent)))
        }
    }
    
    // Extra Credit #2
    func convert() {
        switch type {
            case .Hourly(let salary):
                self.type = JobType.Salary(UInt(round(2000.0 * salary / 1000) * 1000))
            default:
                print("Job type is already a salary job")
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName: String
    let lastName: String
    let age: Int
    var _job: Job?
    var _spouse: Person?
    var job: Job? {
        get {
            return self._job
        }
        set(newValue) {
            if self.age < 18 {
                self._job = nil
            } else {
                self._job = newValue
            }
        }
    }
    
    var spouse: Person?{
        get {
            return self._spouse
        }
        set(newValue) {
            if self.age < 18 {
                self._spouse = nil
            } else {
                self._spouse = newValue
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        var personJob: String
        var personSpouse: String
        if self.job == nil {
            personJob = "nil"
        } else {
            personJob = "\(self.job!)"
        }
        if self.spouse == nil {
            personSpouse = "nil"
        } else {
            personSpouse = "\(self.spouse!)"
        }
        
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(personJob) spouse:\(personSpouse)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var _members: [Person]?
    var members: [Person]? {
        get {
            return self._members
        }
        set(newValue) {
            if self._members != nil && self._members!.count < 2 {
                self._members = nil
            } else {
                self._members = newValue
            }
        }
    }
    
    init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members = [spouse1, spouse2]
        } else {
            members = nil
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        if self.members != nil && (self.members![0].age > 21 || self.members![1].age > 21) {
            self.members?.append(child)
            return true
        } else {
            return false
        }
    }
    
    func householdIncome() -> Int {
        var totalIncome = 0
        for member in self.members! {
            if member.job != nil {
                totalIncome += member.job!.calculateIncome(2000)
            }
        }
        return totalIncome
    }
}
