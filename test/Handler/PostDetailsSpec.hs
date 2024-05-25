module Handler.PostDetailsSpec (spec) where

import TestImport

spec :: Spec
spec = withApp $ do
    describe "getPostDetailsR" $ do
        it "loads post details page" $ do
            get AuthorsR
            statusIs 200
