import ConnFu

runConnFu :: AuthToken -> IO ()
runConnFu token = undefined

main :: IO ()
main = do
         token <- readFile "token.dat"
         runConnFu token
