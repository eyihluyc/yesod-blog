{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Handler.AuthorIndex where

import Import

getAuthorIndexR :: Handler Html
getAuthorIndexR = do
    allAuthors <- runDB $ selectList [] [Desc AuthorId]
    defaultLayout $ do
        $(widgetFile "authors/index")
