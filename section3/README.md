# Untyped Arithmetic Expressions

## 3.1 Introduction

## 3.2 Syntax

## 3.3 Induction on Terms

## 3.4 Semantic Styles

## 3.5 Evaluation

  * term 跟 value 是不一樣的耶。 value 是 evaluation 的可能結果。

  * nv 是 numeric value ，集合比 term 小。像在 `pred (succ (pred 0))` 中不可以把最裡面的 `pred 0` 直接送給 `pred (succ nv) -> nv` （<span class="small-caps">E-PredSucc</span>）。得一步步從 `pred 0 -> 0` 開始。

  * 沒有定義怎麼 evaluate 的 term 叫 stuck 、卡住，它的 normal form 就是他自己。

  * 沒有 `0 -> 0` 耶！也沒有什麼 `t` 的 `succ t -> 0` 。只有 `pred 0 -> 0` （<span class="small-caps">E-PredZero</span>）和 `pred (succ 0) -> 0` （<span class="small-caps">E-PredSucc</span>）。

  * 在 arthmetic expressions 中， <span class="small-caps">E-PredSucc</span> 是必要的，不然 `pred (succ (succ 0))` 會卡住。

  * 沒有 `succ (pred nv) -> nv` （<span class="small-caps">E-SuccPred</span>），不然會出現 `succ (pred 0) -> succ 0` ，且 `succ (pred 0) -> 0` 這種事。但 `succ (pred (succ 0))` 不管有沒有 <span class="small-caps">E-SuccPred</span> 都得到一樣的結果。

