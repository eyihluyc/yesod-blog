{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE NoImplicitPrelude #-}

module TestImport (
    module TestImport,
    module X,
) where

import Application (makeFoundation, makeLogWare)
import ClassyPrelude as X hiding (Handler, delete, deleteBy)
import Database.Persist as X hiding (get)
import Database.Persist.Sql (SqlPersistM, rawExecute, rawSql, runSqlPersistMPool, unSingle)
import Database.Persist.SqlBackend (getEscapedRawName)
import Foundation as X
import Model as X
import Test.Hspec as X
import Text.Shakespeare.Text (st)
import Yesod.Auth as X
import Yesod.Core.Unsafe (fakeHandlerGetLogger)
import Yesod.Default.Config2 (loadYamlSettings, useEnv)
import Yesod.Test as X

runDB :: SqlPersistM a -> YesodExample App a
runDB query = do
    app <- getTestYesod
    liftIO $ runDBWithApp app query

runDBWithApp :: App -> SqlPersistM a -> IO a
runDBWithApp app query = runSqlPersistMPool query (appConnPool app)

runHandler :: Handler a -> YesodExample App a
runHandler handler = do
    app <- getTestYesod
    fakeHandlerGetLogger appLogger app handler

withApp :: SpecWith (TestApp App) -> Spec
withApp = before $ do
    settings <-
        loadYamlSettings
            ["config/test-settings.yml", "config/settings.yml"]
            []
            useEnv
    foundation <- makeFoundation settings
    wipeDB foundation
    logWare <- liftIO $ makeLogWare foundation
    return (foundation, logWare)

-- This function will truncate all of the tables in your database.
-- 'withApp' calls it before each test, creating a clean environment for each
-- spec to run in.
wipeDB :: App -> IO ()
wipeDB app = runDBWithApp app $ do
    tables <- getTables
    sqlBackend <- ask

    -- TRUNCATEing all tables is the simplest approach to wiping the database.
    -- Should your application grow to hundreds of tables and tests,
    -- switching to DELETE could be a substantial speedup.
    -- See: https://github.com/yesodweb/yesod-scaffold/issues/201
    let escapedTables = map (\t -> getEscapedRawName t sqlBackend) tables
        query = "TRUNCATE TABLE " ++ intercalate ", " escapedTables
    rawExecute query []

getTables :: DB [Text]
getTables = do
    tables <-
        rawSql
            [st|
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE';
    |]
            []

    return $ map unSingle tables

{- | Authenticate as a user. This relies on the `auth-dummy-login: true` flag
 being set in test-settings.yaml, which enables dummy authentication in
 Foundation.hs
-}
authenticateAs :: Entity Author -> YesodExample App ()
authenticateAs (Entity _ u) = do
    request $ do
        setMethod "POST"
        addPostParam "ident" $ authorEmail u
        setUrl $ AuthR $ PluginR "authEmail" []

{- | Create a user.  The dummy email entry helps to confirm that foreign-key
 checking is switched off in wipeDB for those database backends which need it.
-}
createAuthor :: Text -> YesodExample App (Entity Author)
createAuthor email = runDB $ do
    insertEntity
        Author
            { authorEmail = email
            , authorPassword = Nothing
            , authorVerkey = Nothing
            , authorVerified = True
            }
