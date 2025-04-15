module ParseState
  ( -- * Context
    ParseContext (Ctx, programText, lineNo),
    newContext,

    -- * State monad
    ParseState,
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

-- | Change the current program text.
updateText :: String -> ParseState ()
updateText text = modify $ \(Ctx _ lineNo) -> Ctx text lineNo
