{-# LANGUAGE OverloadedStrings #-}

module Handler.AuthorDetailsSpec (spec) where

import TestImport

spec :: Spec
spec = withApp $ do
    describe "getAuthorDetailsR" $ do
        it "loads author's details" $ do
            (Entity authorId _) <- createAuthor "testuser1@gmail.com"

            get (AuthorDetailsR authorId)
            statusIs 200
