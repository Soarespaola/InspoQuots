

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
 

    let productID = "com.londonappbrewery.InspoQuotes.PremiumQuotes"
    
    var quotesToShow = [
        
        "Nossa maior glória não é nunca cair, mas levantar toda vez que caímos. - Confúcio",
        "Todos os nossos sonhos podem se tornar realidade, se tivermos coragem de persegui-los. – Walt Disney",
        "Não importa o quão devagar você vá, desde que você não pare. – Confúcio",
        "Tudo o que você sempre quis está do outro lado do medo. - George Addair",
        "O sucesso não é definitivo, o fracasso não é fatal: é a coragem de continuar que conta. – Winston Churchill",
        "Dificuldades muitas vezes preparam pessoas comuns para um destino extraordinário. - C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Acredite em si mesmo. Você é mais corajoso do que pensa, mais talentoso do que imagina e capaz de mais do que imagina. ― Roy T. Bennett",
        "Aprendi que a coragem não era a ausência do medo, mas o triunfo sobre ele. O homem corajoso não é aquele que não sente medo, mas aquele que vence esse medo. – Nelson Mandela",
        "Só há uma coisa que torna um sonho impossível: o medo do fracasso. ― Paulo Coelho",
        "Não é se você é derrubado. É se você se levanta. – Vince Lombardi",
        "Seu verdadeiro sucesso na vida só começa quando você assume o compromisso de se tornar excelente no que faz. — Brian Tracy",
        "Acredite em si mesmo, enfrente seus desafios, mergulhe fundo dentro de você para vencer os medos. Nunca deixe ninguém te derrubar. Você tem que continuar. - Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)
        
    
        
        
   

        
    let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
               navigationItem.standardAppearance = appearance
               navigationItem.scrollEdgeAppearance = appearance
  

        if isPurchased() {
            showPremiumQuotes()
        
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        

        if isPurchased() {
            return quotesToShow.count
        } else {
        return quotesToShow.count + 1
        }
        
        
      
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        
        

        if indexPath.row < quotesToShow.count{
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Obter mais citações"
            cell.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
   

    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
            
        }
            
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - In-App Purchase Methods
    
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
         
            
           let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            
            
        } else {
       
            print("User can't make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                
         
                print("Transaction successful!")
                
                showPremiumQuotes()
                
               
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == .failed {
                
               

                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                }
                
                 SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == .restored {
                
                showPremiumQuotes()
                
                print("Transaction restored")
                
                navigationItem.setRightBarButton(nil, animated: true)
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
        
    }
    
    func showPremiumQuotes() {
        
        UserDefaults.standard.set(true, forKey: productID)
        
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
        
    }
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchaseStatus {
            print("Previously purchased")
            return true
        } else {
            print("Never purchased")
            return false
        }
    }
    
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    

}
