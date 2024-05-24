{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Handler.PostDetails where

import Import

getPostDetailsR :: BlogPostId -> Handler Html
getPostDetailsR blogPostId = do
    blogPost <- runDB $ get404 blogPostId
    authorId <- return $ blogPostAuthorId blogPost
    author <- runDB $ get404 authorId
    defaultLayout $ do
        $(widgetFile "postDetails/post")