module ConnFu (
        -- Data definitions
        CFMessage
        , Channel(..)
        , AuthToken

        -- DSL
        , listenChannel
        )
where

-- The incomming message type
data CFMessage = CFMessage Int String String String Channel

data Channel = RSS
             | SMS
             | Voice
             | Twitter

type AuthToken = String

-- Create a new stream of events
listenChannel :: AuthToken -> Channel -> IO [CFMessage]
listenChannel token channel = undefined
