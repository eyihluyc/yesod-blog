module Handler.AuthorsSpec (spec) where

import TestImport

spec :: Spec
spec = withApp $ do
    describe "getAuthorsR" $ do
        it "loads the users" $ do
            get AuthorsR
            statusIs 200
