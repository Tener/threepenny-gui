{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS -fno-warn-name-shadowing #-}
{-# OPTIONS -fno-warn-type-defaults #-}

module Main where

import Control.Monad.Extra
import Data.Maybe
import Graphics.UI.Ji
import Graphics.UI.Ji.Types

-- | Main entry point. Starts a ji server.
main :: IO ()
main = serve 10002 worker

-- | A per-user worker thread. Each user session has a thread.
worker :: Session -> IO ()
worker session = runJi session $ do
  body <- getElementByTagName "body"
  whenJust body $ \body -> do
    headerMe <- attribution body
    missingDollarRiddle body headerMe
    handleEvents

attribution :: Element -> Ji Element
attribution body = do
  header <- newElementText body "h1" "The "
  headerMe <- newElementText header "span" "…"
  newElementText' header "span" " Dollars"
  
  author <- newElementText body "p" "Originally by "
  vex <- link "http://www.vex.net/~trebla/humour/missing_dollar.html"
              "Albert Lai"
  append author vex
  
  return headerMe

missingDollarRiddle :: Element -> Element -> Ji ()
missingDollarRiddle body headerMe = do
  newElementText' body "h2" "The Guests, The Bellhop, And The Pizza"
  -- User input area.
  intro <- newElementText body "p" ""
  let write text = newElementText intro "span" text >> return ()
      writeRef = newElementText intro "span"
      input = inputText intro
  write "Three guests went to a hotel and gave $"
  hotelOut <- input
  write " to the bellhop to buy pizza. The pizza cost only $"
  hotelCost <- input
  write ". Of the $"
  hotelChange <- writeRef ""
  write " change, the bellhop kept $"
  hotelHold <- input
  write " to himself and returned $"
  hotelRet <- writeRef ""
  write " to the guests."
  -- Conclusion paragraph.
  conclude <- newElementText body "p" ""
  let write text = newElementText conclude "span" text >> return ()
      writeRef = newElementText conclude "span"
  write "So the guests spent $"
  hotelBal <- writeRef ""
  write ", and the bellhop pocketed $"
  hotelPocket <- writeRef ""
  write ". Now "
  write "$"
  hotelBal2 <- writeRef ""
  write "+$"
  hotelPocket2 <- writeRef ""
  write "=$"
  hotelSum <- writeRef ""
  write ". Where did the "
  hotelMe <- writeRef ""
  write "!"
  -- Update procedure.
  let updateDisplay out cost hold = do
        let change = out - cost
            ret = change - hold
            bal = out - ret
            sum = bal + hold
            diff = sum - out
        setAttr hotelOut "value" (show out)
        setAttr hotelCost "value" (show cost)
        setAttr hotelHold "value" (show hold)
        setText hotelChange (show change)
        setText hotelRet (show ret)
        setText hotelBal (show bal)
        setText hotelPocket (show hold)
        setText hotelBal2 (show bal)
        setText hotelPocket2 (show hold)
        setText hotelSum (show sum)
        if diff >= 0
           then do setText hotelMe $ "extra $" ++ show diff ++ " come from"
                   setText headerMe "Extra"
           else do setText hotelMe $ "missing $" ++ show (-diff) ++ " go"
                   setText headerMe "Missing"
  -- Calculate button.
  calculate <- newElementText body "button" "Calculate"
  onClick calculate $ \_ -> do
    getout  <- readValue hotelOut
    getcost <- readValue hotelCost
    gethold <- readValue hotelHold
    fromMaybe (return ()) $ do
      out  <- getout
      cost <- getcost
      hold <- gethold
      return $ updateDisplay out cost hold
  -- 
  updateDisplay 30 25 2

  where inputText parent = do
          el <- newElement "input"
          setAttr el "type" "text"
          setAttr el "size" "3"
          append parent el
          return el

link :: String -> String -> Ji Element
link url text = do
  el <- newElement "a"
  setAttr el "href" url
  setText el text
  return el

newElementText :: Element -> String -> String -> Ji Element
newElementText parent tagName text = do
  el <- newElement tagName
  append parent el
  setText el text
  return el

newElementText' :: Element -> String -> String -> Ji ()
newElementText' parent tagName text =
  newElementText parent tagName text >> return ()