{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Email (Email, mkEmail, getEmail) where

import ClassyPrelude.Yesod
import Data.Text (append)
import Database.Persist.Sql (PersistFieldSql (..))
import Text.Blaze.Html5
import qualified Text.Email.Validate as EV

newtype Email = Email {getEmail :: Text}
    deriving (Show, Eq, Ord)

mkEmail :: Text -> Either Text Email
mkEmail email =
    case EV.validate (encodeUtf8 email) of
        Left err -> Left (pack err)
        Right _ -> Right (Email email)

instance PersistField Email where
    toPersistValue email = toPersistValue (getEmail email)
    fromPersistValue v = do
        textValue <- fromPersistValue v
        case mkEmail textValue of
            Right email -> Right email
            Left errMsg -> Left $ append "Invalid email: " errMsg

instance PersistFieldSql Email where
    sqlType _ = SqlString

instance ToMarkup Email where
    toMarkup = toHtml . getEmail
