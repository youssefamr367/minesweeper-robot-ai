type Cell = (Int,Int)
data MyState = Null | S Cell [Cell] String MyState deriving (Show,Eq)

up :: MyState -> MyState
up (S (0,_) _ _ _) = Null
up (S (x,y) l e f) = (S ((x-1),y) l "up" (S (x,y) l e f))

down :: MyState -> MyState
down (S (3,_) _ _ _) = Null
down (S (x,y) l e f) = (S ((x+1),y) l "down" (S (x,y) l e f))

left :: MyState -> MyState
left (S (_,0) _ _ _) = Null
left (S (x,y) l e f) = (S (x,y-1) l "left" (S (x,y) l e f))

right :: MyState -> MyState
right (S (_,3) _ _ _) = Null
right (S (x,y) l e f) = (S (x,y+1) l "right" (S (x,y) l e f))

collect :: MyState -> MyState
collect (S x l e f) = if elem x l then (S x (remove_one l x) "collect" (S x l e f)) else Null

nextMyStates::MyState->[MyState]
nextMyStates x = filter (/=Null) [up x, down x, left x, right x, collect x]

nextMyStates_array ::[MyState] -> [MyState]
nextMyStates_array [] = []
nextMyStates_array (h:t) = (nextMyStates h) ++ (nextMyStates_array t) 

isGoal::MyState->Bool
isGoal (S _ [] _ _) = True
isGoal (S _ x _ _) = False

isGoal_array :: [MyState]->Bool
isGoal_array [] = False
isGoal_array (h:t) = if isGoal h then True else isGoal_array t

search_helper [] = Null
search_helper (h:t) = if isGoal h then h else search_helper t

search:: [MyState] -> MyState
search (h:t) = if isGoal_array (h:t) then search_helper (h:t) else search (nextMyStates_array (h:t))

constructSolution:: MyState -> [String]
constructSolution Null = []
constructSolution (S _ _ x f) = if x == "" then constructSolution f else constructSolution f ++ [x]  

solve :: Cell->[Cell]->[String]
solve x y = constructSolution (search [S x y "" Null]) 

remove_one :: (Eq a) => [a] -> a -> [a]
remove_one = \list -> \v -> 
    case list of 
        [] -> error "Element not found!"
        x:xs | v==x -> xs
        x:xs -> x:remove_one xs v