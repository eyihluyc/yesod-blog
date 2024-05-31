{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE BlockArguments #-}

module Handler.Home where
import qualified Database.Esqueleto.Experimental as E
import Import

getHomeR :: Handler Html
getHomeR = do
    allPosts <- runDB $
        E.select do
            (blog_post E.:& author) <- E.from $ 
                E.table @BlogPost
                `E.InnerJoin` E.table @Author
                `E.on` (\(blog_post E.:& author) -> 
                    blog_post E.^. BlogPostAuthorId E.==. author E.^. AuthorId)
            return 
                ( blog_post E.^. BlogPostId
                , blog_post E.^. BlogPostTitle
                , author E.^. AuthorEmail
                , author E.^. AuthorId
                )
    defaultLayout $ do
        $(widgetFile "posts/index")
