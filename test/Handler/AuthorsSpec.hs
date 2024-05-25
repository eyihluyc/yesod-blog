module Handler.AuthorsSpec (spec) where

import TestImport

spec :: Spec
spec = withApp $ do
    describe "getAuthorsR" $ do
        it "todo" $ \_ -> pending
