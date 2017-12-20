## Introduction

In this tutorial we're going to convert part of a tiny React application into Elm. Here's what the final version of the app is going to look like:

![final tic tac toe](readme-content/final-tictactoe.jpg)

The block of grey buttons on the right represents the history of the tic tac toe game. You can click the various buttons to jump to different points in the game's history. It is this history feature of the tic tac toe game that we'll be converting to Elm. Everything else will be left as it was in React.

## Prerequisites: node and webpack

It's unlikely that you've come to this tutorial without knowing what nodejs is. And it's likely you've already got nodejs installed. But if you don't, install it. You're gonna need it.

Once you've got node installed, you'll want to use npm (it comes with nodejs) to install webpack:

```
npm install webpack --global
```

The trickiest bit of this whole tutorial is webpack configuration. Webpack is a bundling tool, and sometimes it changes. It's possible that the webpack.config.js file in this repo will be outdated to the point of not working by the time you are working through this tutorial. So the very first thing you'll want to do after cloning this repo is to run

```
webpack -d
```

If there aren't any errors - Congratulations! You're past the bumpiest part of this tutorial! If there were errors, then you have my sympathy. I'll be glad to update this tutorial once you've told me about the problem. Or you could figure it out yourself if you prefer. Webpack is kind of unescapable, I think. You might as well buckle down and learn it, and that's not too difficult.

## Some stuff that I did before you got here

We're going to be doing all of our coding in index.jsx. As I explained up in the introduction, we're going to be converting the history part of this tic tac toe app over to Elm. The first two steps of that process are to remove all history managing code from the Game component in our React source, and port that history managing code over to Elm. "No fair!" you might say, "I wanted to write the Elm." I'm sorry, but interop is the focus of this tutorial, and I'm trying my best to keep a laser focus on interop. Writing the history code in Elm is pretty easy, and you can do that for fun once we've finished the tutorial!

## Ok, we're finally read to do the Elm interop

There is a simple, two step process for interop with Elm:

1. Embed Elm in your webpage
2. Hook up the ports

So easy that anyone can do it! But before we do it, open up index.jsx in your favorite text editor (if you haven't yet), and I'll point out a couple of important things.

Among the import statements at the top of the file, you'll find one like this:

```
import Elm from './elm-component'
```

elm-component is a React component. It is a generic React component for embedding Elm wherever you want it. The source is included in this repo if you want to check it out. You'll see how we use it in just a moment.

Right below the import of elm-component you'll find this guy

```
import { ElmHistoryModule } from './ElmHistoryModule'
```

ElmHistoryModule.elm contains our Elm code. The source. Uncompiled. Through the magic of webpack (and elm-webpack-loader), ElmHistoryModule will get compiled and bundled up with all the rest our javascript.

To complete step 1 of our two step interop process, scroll down to the bottom of the render function in the Game component. The bottom of that render function looks like this:

```jsx
return (
    <div className="game">
        <div className="game-board">
            <Board
                squares={current.squares}
                onClick={i => this.handleClick(i)} />
        </div>
        <div className="game-info">
          <div>{status}</div>
        </div>
    </div>
);

```

We are going to add a new element to the "game-info" so that it looks like this:

```jsx
<div class="game-info">
	<div>{status}</div>
	<Elm src={ElmHistoryModule} />
</div>
```

And that's all it takes to complete step 1! Now for a brief interlude wherein we startup webpack and a webserver of your choice.

## A brief interlude wherein we start webpack and a webserver of your choice

In your favorite command shell, navigate to the folder containing our tutorial code and run

```
webpack -d --watch
```

webpack should build and bundle our javascript, and then it should continue running. That's because we've started webpack in watch mode. We've got more changes to make in index.jsx, and we want webpack to build automatically as we save those changes.

In another command shell, start up a web server of your choice. Then browse to index.html in your favorite browser. At this point, our tic tac toe app should look like this:

![Elm is embedded](readme-content/after-embedding.jpg)

The game board still works perfectly (try it), but the history feature is now broken. But it totally makes sense for the history feature to be broken. We've not yet finished step 2 of our two step interop process - we still need to hook up the ports!

## Hooking up the ports