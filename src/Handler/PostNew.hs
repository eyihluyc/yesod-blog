{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Handler.PostNew where

import Import
import Yesod.Form.Bootstrap3
import Yesod.Markdown (markdownField)

blogPostForm :: UserId -> AForm Handler BlogPost
blogPostForm userId = BlogPost
    <$> areq textField (bfs ("Title" :: Text)) Nothing
    <*> areq markdownField (bfs ("Article" :: Text)) Nothing
    <*> pure userId

getPostNewR :: Handler Html
getPostNewR = do
    userID <- requireAuthId
    (widget, enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm (blogPostForm userID)
    defaultLayout $ do
        setTitle "New Post"
        $(widgetFile "posts/new")

postPostNewR :: Handler Html
postPostNewR = do
    userID <- requireAuthId
    ((res, widget), enctype) <- runFormPost $ renderBootstrap3 BootstrapBasicForm (blogPostForm userID)
    case res of
        FormSuccess blogPost -> do
            let blogPostWithUser = blogPost { blogPostAuthorId = userID }
            blogPostId <-runDB $ insert blogPostWithUser
            redirect $ PostDetailsR blogPostId
        _ -> defaultLayout $(widgetFile "posts/new") 