//
//  ContentView.swift
//  TicTacToe Simple
//
//  Created by Steven Slater on 24/02/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            
            VStack {
                
            
                Text("Tic Tac Toe")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .fontWeight(.light)
                    .underline(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: .white)
                
                
               
               Spacer()
                
                NavigationLink(destination : twoPlayer()) {
                    Text("Play Two Player")
                    .font(.system(size: 30))
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .fontWeight(.heavy)
                }
                
                Spacer()
                
                NavigationLink(destination : computer(board: Board(), solver: Solver(maxDepth : 0))) {
                    Text("Play Computer")
                    .font(.system(size: 30))
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .fontWeight(.heavy)
                    
                   
                }
                
                Spacer()
                
                Spacer()
                
            }
            .navigationTitle(Text(""))
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct twoPlayer : View {
    
    @State var moves = [String](repeating: "", count: 9)
    @State var turn : Bool = true //p1 is true to start
    @State var gameOver : Bool = false
    @State var msg : String = ""
    @State var count : Int = 0
  

    var board = Board()
    var body: some View {
        
        
        
        VStack {
            
            Text("Tic Tac Toe")
            .font(.system(size: 30))
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .fontWeight(.heavy)
            
            Text("Two Player")
            .font(.system(size: 20))
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .fontWeight(.heavy)
            
            
            Spacer()
            
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 15), count: 3), spacing: 15) {
                
                ForEach(0..<9,id: \.self) { index in
                    
                    ZStack {
                        Color.white
                        
                        Text(moves[index])
                            .font(.system(size: 55))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .fontWeight(.heavy)
                        
                        
                    }
                    .frame(width: getWidth(), height: getWidth(), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(15)
                    .onTapGesture(perform: {
                        
                        withAnimation(Animation.easeIn(duration : 0.2)) {
                            
                            if moves[index] == "" {
                                moves[index] = turn ? "X" : "O"
                                count += 1
                                turn.toggle()
                            }
                        }
                    })
                    
                }
                
            }.padding(15)
            
            Spacer()
        }
        
        
        
        .onChange(of: moves, perform: { value in
                checkWinner()
        })
        .alert(isPresented: $gameOver, content: {
            
            Alert(title: Text("Game Over"), message: Text(msg),dismissButton: .destructive(Text("Play Again"), action: {
                
                withAnimation(Animation.easeOut(duration : 0.5)) {
                    
                    moves.removeAll()
                    moves = [String](repeating: "", count: 9)
                    turn.toggle()
                    count = 0
                    
                }
            }))
        })

        
        
    }
    
    func getWidth() -> CGFloat {
        
       let width = UIScreen.main.bounds.width - (30 + 30)
        
        return width / 3
    }

    func checkWinner() -> Void {
        
        if win() && !turn {
            msg = "Player X Won!"
            gameOver.toggle()
        } else if win() && turn {
            msg = "Player O Won!"
            gameOver.toggle()
        } else if count == 9 {
            msg = "Game tied"
            gameOver.toggle()
        }
      
        
        
    }
        
    
    func win() -> Bool {
        let combos : [[Int]] = [
            [0,1,2],
            [3,4,5],
            [6,7,8],
            [0,3,6],
            [1,4,7],
            [2,5,8],
            [0,4,8],
            [2,4,6]
        ]
        for c in combos {
            if moves[c[0]] != "" && moves[c[0]] == moves[c[1]] && moves[c[0]] == moves[c[2]] {
                return true
            }
        }
        return false
    }
}

struct computer : View {
    
    //var mode : String
    @State var gameOver : Bool = false
    @State var msg : String = ""
    @State var mode : String = ""
    @State var tappedEasy : Bool = true
    @State var tappedMed : Bool = false
    @State var tappedHard : Bool = false
    @State var display = [String](repeating: "", count: 9)
    var board : Board
    var solver : Solver
   
    
    var body: some View {
        
        
        
        VStack {
         
            
            
            Text("Tic Tac Toe")
            .font(.system(size: 30))
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .fontWeight(.heavy)
            
            Text("Computer")
            .font(.system(size: 20))
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .fontWeight(.heavy)
            
            Spacer()
            
            
            
            Spacer()
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    tappedEasy = true
                    tappedMed = false
                    tappedHard = false
                    mode = "E"
                    solver.maxDepth = 2
                    display = [String] (repeating: "", count: 9)
                    board.reset()
                  
                }) {
                    if tappedEasy {
                        Text("Easy")
                            .fontWeight(.heavy)
                            .padding(8)
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .cornerRadius(15)
                            
                            
                           
                    } else {
                        Text("Easy")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .fontWeight(.heavy)
                            
                    }
                }
                
                Spacer()
                
                Button(action: {
                    tappedEasy = false
                    tappedMed = true
                    tappedHard = false
                    mode = "M"
                    solver.maxDepth = 3
                    display = [String] (repeating: "", count: 9)
                    board.reset()
                }) {
                    if tappedMed {
                        Text("Medium")
                            .fontWeight(.heavy)
                            .padding(8)
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .cornerRadius(15)
                            
                    } else {
                        Text("Medium")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .fontWeight(.heavy)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    tappedEasy = false
                    tappedMed = false
                    tappedHard = true
                    mode = "H"
                    solver.maxDepth = 9
                    display = [String] (repeating: "", count: 9)
                    board.reset()
                    
                }) {
                    if tappedHard {
                        Text("Hard")
                            .fontWeight(.heavy)
                            .padding(8)
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .cornerRadius(15)
                            
                    } else {
                        Text("Hard")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .fontWeight(.heavy)
                    }

                }
               
                
               Spacer()

            }
            
           Spacer()
            
    
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 15), count: 3), spacing: 15) {
                
                ForEach(0..<9,id: \.self) { index in
                    
                    ZStack {
                        Color.white
                        
                        Text(display[index])
                            .font(.system(size: 55))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .fontWeight(.heavy)
                        
                        
                    }
                    .frame(width: getWidth(), height: getWidth(), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(15)
                    .onTapGesture(perform: {
                        
                       
                            withAnimation(Animation.easeIn(duration : 0.2)) {
                                
                                if board.valid(index : index) && !board.win() {
                                    display[index] = "X"
                                   
                                    board.move(index: index)
                                    
                                    if board.count < 9 && !board.win() {
                                        let move = solver.solve(board: board)
                                        display[move] = "O"
                                       
                                        board.move(index: move)
                                        
                                    }
                                }
                            }
                            
                        
                       
                    })
                    
                  
                }
                
                
            }.padding(15)
            
           
      
            
            Spacer()
        }
        .onChange(of: board.grid, perform: { value in
            checkWinner()
        })
        .alert(isPresented: $gameOver, content: {
            
            Alert(title: Text("Game Over"), message: Text(msg),dismissButton: .destructive(Text("Play Again"), action: {
                
                withAnimation(Animation.easeOut(duration : 0.5)) {
                    display = [String] (repeating: "", count: 9)
                    board.reset()
                }
            }))
        })
        
        
        
    }
    
    func getWidth() -> CGFloat {
        
       let width = UIScreen.main.bounds.width - (30 + 30)
        
        return width / 3
    }

    func checkWinner() -> Void {
        
        if board.win() {
            if !board.turn {
                msg = "Player X Won!"
            } else {
                msg = "Player O Won!"
            }
            gameOver.toggle()
        } else if board.draw() {
            msg = "Game tied"
            gameOver.toggle()
        }
    }
}
 
 
        

class Board {
    var grid : [Int]
    var turn : Bool
    var count : Int
    
    init () {
        self.count = 0
        self.turn = true //true
        self.grid = [Int] (repeating: 0, count: 9)
    }
    
    init (grid : [Int], turn : Bool, count : Int) {
        self.count = count
        self.turn = turn
        self.grid = grid
    }
    
    func reset() -> Void {
        count = 0
        turn = true
        grid = [Int] (repeating: 0, count: 9)
    }
    
    func move(index : Int) -> Void {
        grid[index] = turn ? 1 : 2
        turn = !turn
        count += 1
    }
    
    func undo(index : Int) -> Void {
        grid[index] = 0
        turn = !turn
        count -= 1
    }
    
    func possible() -> [Int] {
        var moves : [Int] = [Int] ()
        for i in 0..<9 {
            if grid[i] == 0 {
                moves.append(i)
            }
        }
        return moves
    }
    
    func boards() -> [(Board, Int)] {
        var boards : [(Board, Int)] = [(Board, Int)] ()
        var board : Board
        for move in possible() {
            board = Board(grid: grid, turn: turn, count: count)
            board.move(index: move)
            boards.append((board, move))
        }
        return boards
    }
    
    func valid(index : Int) -> Bool {
        return grid[index] == 0
    }
    
    func win() -> Bool {
        let combos : [[Int]] = [
            [0,1,2],
            [3,4,5],
            [6,7,8],
            [0,3,6],
            [1,4,7],
            [2,5,8],
            [0,4,8],
            [2,4,6]
        ]
        for c in combos {
            if grid[c[0]] != 0 && grid[c[0]] == grid[c[1]] && grid[c[0]] == grid[c[2]] {
                return true
            }
        }
        return false
    }
    
    func draw() -> Bool {
        return count == 9
    }
}

class Solver {
    var maxDepth : Int
    
    init (maxDepth : Int) {
        self.maxDepth = maxDepth
    }
    
    func solve(board : Board) -> Int {
        var bestMoves : [Int] = [Int] ()
        var bestScore : Int = Int.min
        //var bestmove : Int
        var score : Int
        for (possible, move) in board.boards() {
            if possible.win() {
                return move
            }
            score = minimax(board: possible, depth: maxDepth, alpha : Int.min, beta : Int.max)
            if score > bestScore {
                bestScore = score
               // bestmove = move
                bestMoves.removeAll()
            }
            if score == bestScore {
                bestMoves.append(move)
            }
        }
        let rand = Int.random(in: 0..<bestMoves.count)
        return bestMoves[rand]
      //  return bestmove
    }
    
    func minimax(board : Board, depth : Int, alpha : Int, beta : Int) -> Int {
        if (depth == 0) {
            return 0
        } else if (board.win()) {
            return board.turn ? 10-board.count : board.count-10 //return board.turn ? 10 : -10
        } else if (board.draw()) {
            return 0
        }
        var score : Int
        var cutoff : Int
        if (board.turn) { // human
            score = Int.max
            cutoff = beta
            for (possible, _) in board.boards() {
                score = min(score, minimax(board: possible, depth: depth-1, alpha: alpha, beta: cutoff))
                cutoff = min(score, cutoff)
                if alpha >= cutoff {
                    break
                }
            }
            return score
        } else { // ai
            score = Int.min
            cutoff = alpha
            for (possible, _) in board.boards() {
                score = max(score, minimax(board: possible, depth: depth-1, alpha: cutoff, beta: beta))
                cutoff = max(score, cutoff)
                if cutoff >= beta {
                    break
                }
            }
            return score
        }
    }
}
    
