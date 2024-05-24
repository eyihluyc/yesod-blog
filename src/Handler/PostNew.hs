{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Handler.PostNew where

import Import
import Yesod.Form.Bootstrap3
import Yesod.Markdown (markdownField)

blogPostForm :: AuthorId -> AForm Handler BlogPost
blogPostForm authorId = BlogPost
    <$> areq textField (bfs ("Title" :: Text)) Nothing
    <*> areq markdownField (bfs ("Article" :: Text)) Nothing
    <*> pure authorId

getPostNewR :: Handler Html
getPostNewR = do
    authorID <- requireAuthId
    (widget, enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm (blogPostForm authorID)
    defaultLayout $ do
        setTitle "New Post"
        $(widgetFile "posts/new")

postPostNewR :: Handler Html
postPostNewR = do
    authorID <- requireAuthId
    ((res, widget), enctype) <- runFormPost $ renderBootstrap3 BootstrapBasicForm (blogPostForm authorID)
    case res of
        FormSuccess blogPost -> do
            let blogPostWithAuthor = blogPost { blogPostAuthorId = authorID }
            blogPostId <-runDB $ insert blogPostWithAuthor
            redirect $ PostDetailsR blogPostId
        _ -> defaultLayout $(widgetFile "posts/new") 