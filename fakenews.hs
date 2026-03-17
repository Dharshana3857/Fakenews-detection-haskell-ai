import System.IO
import System.Process
import Data.Char
import Data.List

-------------------------------------------------
-- Keyword Lists
-------------------------------------------------

fakeKeywords :: [String]
fakeKeywords =
 ["breaking","shocking","secret","conspiracy","fraud","scandal",
  "leaked","exclusive","urgent","miracle","exposed","rumor",
  "panic","danger","bombshell","sensational"]

clickbaitWords :: [String]
clickbaitWords =
 ["unbelievable","amazing","incredible","you","won't","believe",
  "secret","revealed","exposed","truth","shocking"]

-------------------------------------------------
-- Text Cleaning
-------------------------------------------------

cleanText :: String -> String
cleanText = map toLower . map replace
  where
    replace c = if isAlpha c then c else ' '

-------------------------------------------------
-- Tokenization
-------------------------------------------------

tokenize :: String -> [String]
tokenize = words . cleanText

-------------------------------------------------
-- Keyword Counter
-------------------------------------------------

countKeywords :: [String] -> [String] -> Int
countKeywords keywords ws =
 length (filter (`elem` keywords) ws)

-------------------------------------------------
-- Capital Letter Ratio
-------------------------------------------------

capitalRatio :: String -> Double
capitalRatio text =
 let caps = length (filter isUpper text)
     letters = length (filter isAlpha text)
 in if letters == 0
    then 0
    else fromIntegral caps / fromIntegral letters * 100

-------------------------------------------------
-- Exclamation Count
-------------------------------------------------

exclamationScore :: String -> Double
exclamationScore text =
 let exc = length (filter (=='!') text)
 in fromIntegral exc

-------------------------------------------------
-- Fake Score Calculation
-------------------------------------------------

fakeScore :: Double -> Double -> Double -> Double -> Double
fakeScore kw cb cap exc =
 (kw * 0.4) +
 (cb * 0.2) +
 (cap * 0.2) +
 (exc * 0.2)

-------------------------------------------------
-- Classification
-------------------------------------------------

classify :: Double -> String
classify score
 | score > 25 = "HIGH PROBABILITY OF FAKE NEWS"
 | score > 10 = "SUSPICIOUS NEWS"
 | otherwise  = "LIKELY REAL NEWS"

-------------------------------------------------
-- Main Program
-------------------------------------------------

main :: IO ()
main = do

 putStrLn "-------------------------------------"
 putStrLn "FAKE NEWS DETECTION SYSTEM"
 putStrLn "Haskell Functional Analyzer + AI"
 putStrLn "-------------------------------------"

 putStrLn "Enter news text file:"
 file <- getLine

 content <- readFile file

 let tokens = tokenize content
 let totalWords = length tokens

 -- feature extraction

 let kwMatches = countKeywords fakeKeywords tokens
 let cbMatches = countKeywords clickbaitWords tokens
 let capScore = capitalRatio content
 let excScore = exclamationScore content

 let kwScore = fromIntegral kwMatches / fromIntegral totalWords * 100
 let cbScore = fromIntegral cbMatches / fromIntegral totalWords * 100

 let final = fakeScore kwScore cbScore capScore excScore
 let result = classify final

 -------------------------------------------------
 -- Output
 -------------------------------------------------

 putStrLn ""
 putStrLn "------ HASKELL ANALYSIS ------"

 putStrLn ("Total Words: " ++ show totalWords)

 putStrLn ("Fake Keyword Matches: " ++ show kwMatches)
 putStrLn ("Clickbait Word Matches: " ++ show cbMatches)

 putStrLn ("Keyword Score: " ++ show kwScore ++ "%")
 putStrLn ("Clickbait Score: " ++ show cbScore ++ "%")
 putStrLn ("Capital Letter Score: " ++ show capScore ++ "%")
 putStrLn ("Exclamation Score: " ++ show excScore)

 putStrLn ("Combined Fake Score: " ++ show final ++ "%")

 putStrLn ("Haskell Result: " ++ result)

 -------------------------------------------------
 -- AI Verification
 -------------------------------------------------

 putStrLn ""
 putStrLn "------ AI VERIFICATION ------"

 callCommand ("python predict_news.py " ++ file)