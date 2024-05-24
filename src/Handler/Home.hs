{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import qualified Database.Esqueleto      as E
import           Database.Esqueleto      ((^.))
import Import

getHomeR :: Handler Html
getHomeR = do
    -- allPosts <- runDB $ selectList [] [Desc BlogPostId]
    allPosts <- runDB
        $ E.select
        $ E.from $ \(blog_post `E.InnerJoin` author) -> do
            E.on $ blog_post ^. BlogPostAuthorId E.==. author ^. AuthorId
            return
                ( blog_post   ^. BlogPostId
                , blog_post   ^. BlogPostTitle
                , author      ^. AuthorEmail
                , author      ^. AuthorId
                )
    defaultLayout $ do
        $(widgetFile "posts/index")