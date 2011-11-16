{-# LANGUAGE DeriveDataTypeable #-} 

module ConnFu (
        -- Data definitions
        CFMessage(..)
        , Channel(..)
        , AuthToken

        -- DSL
        , listenChannel
        )
where

import qualified Network.Curl as C
import Text.JSON
import Text.JSON.Generic

-- The incomming message type
data CFMessage = CFMessage {
                    mId::String
                    , mContent::String
                    , mFrom::String
                    , mTo::String
                    , mChannel_type::Channel
                }
                deriving Show

data Channel = RSS
             | SMS
             | Voice
             | Twitter
             deriving Show

type AuthToken = String

-- Create a new stream of events
listenChannel :: AuthToken -> Channel -> (CFMessage -> IO()) -> IO ()
listenChannel token channel action = do
    response <- C.curlGetString connFuURI [createHeaders token]
    mapM_ putStrLn $ (lines.snd) response

 
createHeaders :: AuthToken -> C.CurlOption
createHeaders token  = C.CurlHttpHeaders ["Authorization: Backchat " ++ token]

connFuURI = "https://stream.connfu.com/connfu-stream-testing-emc2"

data SMSJson = SMSJson {
        appId :: String,
        from :: String,
        to :: String,
        message :: String
    } 
    deriving (Show, Data, Typeable)

-- | TODO: create proper test functions
exampleSMS="[\"sms\",{\"appId\":\"connfu-stream-testing-emc2\",\"from\":\"1111\",\"to\":\"441143520203\",\"message\":\"hola\"}]"

jsonToSMS :: JSObject JSValue -> Result SMSJson
jsonToSMS object = do
          appId <- valFromObj "appId" object
          from <- valFromObj "from" object
          to <- valFromObj "to" object
          message <- valFromObj "message" object
          return (SMSJson appId from to message)
    

jsonToMessage :: Channel -> String -> CFMessage
jsonToMessage SMS theJson  = -- | This is a mess because of the JSON definition look at the RSS instead
    let 
        (Ok content) = decode theJson :: Result [JSValue]
        (JSObject value) = content !! 1
        (Ok sms) = jsonToSMS value
    in CFMessage {mId=(appId sms), mFrom=(from sms), mTo=(to sms), mContent=(message sms),mChannel_type=SMS}
 
