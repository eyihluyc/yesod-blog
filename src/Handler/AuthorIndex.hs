{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.AuthorIndex where

import Import

getAuthorIndexR :: Handler Html
getAuthorIndexR = do
    allAuthors <- runDB $ selectList [] [Desc AuthorId]
    defaultLayout $ do
        setTitle "Authors"
        $(widgetFile "authors/index")
