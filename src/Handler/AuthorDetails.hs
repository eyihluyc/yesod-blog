{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.AuthorDetails where

import Import

getAuthorDetailsR :: AuthorId -> Handler Html
getAuthorDetailsR authorId = do
    (author, authorPosts) <- runDB $ do
        author' <- get404 authorId
        authorPosts' <- selectList [BlogPostAuthorId ==. authorId] [Desc BlogPostId]
        pure (author', authorPosts')
    defaultLayout $ do
        setTitle . toHtml $ authorEmail author
        $(widgetFile "authors/details")
