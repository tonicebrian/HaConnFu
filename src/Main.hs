import ConnFu
-- | This function acts on each received message
-- | Supply your own function
action :: CFMessage -> IO ()
action message = putStrLn log
    where
        log = "I just got a new post with title " ++
              (mContent message) ++ " in the channel " ++
              show (mChannel_type message)
    

main :: IO ()
main = do
         token <- readFile "token.dat"
         listenChannel token RSS action
