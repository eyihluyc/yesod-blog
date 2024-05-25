{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Handler.PostDetails where

import Import

getPostDetailsR :: BlogPostId -> Handler Html
getPostDetailsR blogPostId = do
    blogPost <- runDB $ get404 blogPostId
    author <- runDB $ get404 (blogPostAuthorId blogPost)
    defaultLayout $ do
        $(widgetFile "postDetails/post")
