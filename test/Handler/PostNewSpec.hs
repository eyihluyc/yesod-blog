module Handler.PostNewSpec (spec) where

import TestImport

spec :: Spec
spec = withApp $ do
    describe "getPostNewR" $ do
        it "loads the post form" $ do
            get AuthorsR
            statusIs 200

    describe "postPostNewR" $ do
        it "allows to create a post for authenticated user" $ do
            \_ -> pending
