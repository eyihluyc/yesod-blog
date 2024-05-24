{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Handler.Authors where

import Import

getAuthorsR :: Handler Html
getAuthorsR = do
    allAuthors <- runDB $ selectList [] []
    defaultLayout $ do
        $(widgetFile "authors/index")
