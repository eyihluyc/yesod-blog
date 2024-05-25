{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Home where

import Database.Esqueleto ((^.))
import qualified Database.Esqueleto as E
import Import

getHomeR :: Handler Html
getHomeR = do
    allPosts <- runDB $
        E.select $
            E.from $ \(blog_post `E.InnerJoin` author) -> do
                E.on $ blog_post ^. BlogPostAuthorId E.==. author ^. AuthorId
                return
                    ( blog_post ^. BlogPostId
                    , blog_post ^. BlogPostTitle
                    , author ^. AuthorEmail
                    , author ^. AuthorId
                    )
    defaultLayout $ do
        $(widgetFile "posts/index")
