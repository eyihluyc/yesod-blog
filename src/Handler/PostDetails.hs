{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.PostDetails where

import Import

getPostDetailsR :: BlogPostId -> Handler Html
getPostDetailsR blogPostId = do
    (blogPost, author) <- runDB $ do
        blogPost' <- get404 blogPostId
        author' <- get404 (blogPostAuthorId blogPost')
        pure (blogPost', author')
    defaultLayout $ do
        setTitle . toHtml $ blogPostTitle blogPost
        $(widgetFile "postDetails/post")
