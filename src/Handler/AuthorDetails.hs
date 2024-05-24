{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Handler.AuthorDetails where

import Import

getAuthorDetailsR :: AuthorId -> Handler Html
getAuthorDetailsR authorId = do
    author <- runDB $ get404 authorId
    authorPosts <- runDB $ selectList [BlogPostAuthorId ==. authorId] [Desc BlogPostId]
    defaultLayout $ do
        $(widgetFile "authors/details")
