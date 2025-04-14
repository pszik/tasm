module ParseState
  ( -- * Context
    ParseContext (Ctx, programText, lineNo),
    newContext,

    -- * State monad
    ParseState,
    skipWhitespace,
    updateText,
  )
where

import Control.Monad.State (StateT, get, modify, put)
import Data.Char (isSpace)

data ParseContext = Ctx
  { -- | remaining test to be parsed
    programText :: String,
    -- | current line number
    lineNo :: Int
  }

-- | Create a new parse context.
newContext ::
  -- | full text to parse
  String ->
  -- | the context
  ParseContext
newContext text = Ctx text 1

type ParseState = StateT ParseContext (Either String)

-- | Remove all whitespace characters at the head of the text
-- and increment the line numer for every newline character seen.
skipWhitespace :: ParseState ()
skipWhitespace = do
  Ctx txt lineNo <- get
  let (ws, text') = span isSpace txt
  let lineCount = length . filter (== '\n') $ ws
  put $ Ctx text' (lineNo + lineCount)

-- | Change the current program text.
updateText :: String -> ParseState ()
updateText text = modify $ \(Ctx _ lineNo) -> Ctx text lineNo