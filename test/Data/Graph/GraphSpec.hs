module Data.Graph.GraphSpec where

import Test.Hspec
import Test.QuickCheck

import Data.Graph.Graph
import Data.Graph.Types

spec :: Spec
spec = do
    describe "Undirected Graph (Graph)" $ do
        it "Can tell if a vertex exists" $ property $ do
            let g = insertVertex 1 empty :: Graph Int ()
            let g' = insertVertex 2 empty :: Graph Int ()
            containsVertex g 1 `shouldBe` True
            containsVertex g' 1 `shouldBe` False

        it "Can tell if an edge exists" $ property $ do
            let g = insertEdge (1 <-> 2) empty :: Graph Int ()
            containsEdge g (1 <-> 2) `shouldBe` True

        it "Stores symetrical edges" $ property $ do
            let g = insertEdge (2 <-> 1) $ insertEdge (1 <-> 2) empty :: Graph Int ()
            containsEdge g (1 <-> 2) `shouldBe` True
            containsEdge g (2 <-> 1) `shouldBe` True
            length (edges g) `shouldBe` 1

        it "Increments its order when a new vertex is inserted" $ property $
            \g v -> (not $ g `containsVertex` v)
                ==> order g + 1 == order (insertVertex v (g :: Graph Int ()))
        it "Increments its size when a new edge is inserted" $ property $
            \g edge -> (not $ g `containsEdge` edge)
                ==> size g + 1 == size (insertEdge edge (g :: Graph Int ()))

        it "Is id when inserting and removing a new vertex" $ property $
            \g v -> (not $ g `containsVertex` v)
                ==> ((removeVertex v . insertVertex v) g)
                    == (g :: Graph Int ())
