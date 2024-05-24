{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Handler.PostNew where

import Import
import Yesod.Form.Bootstrap3
import Yesod.Markdown (markdownField)

blogPostForm :: AForm Handler BlogPost
blogPostForm = BlogPost
    <$> areq textField (bfs ("Title" :: Text)) Nothing
    <*> areq markdownField (bfs ("Article" :: Text)) Nothing

getPostNewR :: Handler Html
getPostNewR = do
    -- widget is a bundle of html, javascript and css to embed in the page
    -- form is a widget we're going to embed
    (widget, enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm blogPostForm
    defaultLayout $ do
        setTitle "New Post"
        $(widgetFile "posts/new")

postPostNewR :: Handler Html
postPostNewR = do
    ((res, widget), enctype) <- runFormPost $ renderBootstrap3 BootstrapBasicForm blogPostForm
    case res of
        FormSuccess blogPost -> do
            blogPostId <-runDB $ insert blogPost
            redirect $ PostDetailsR blogPostId
        _ -> defaultLayout $(widgetFile "posts/new") 