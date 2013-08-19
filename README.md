# Yomi

Yomi is an iPad app for everyday code reading. 


## Motivation

There are plenty of open source projects from which we developers can learn, by just reading the code thoroughly and carefully. However, sitting in from of the desk for a long time doing serious code reading is not always the easiest thing to do. Sometimes we need more comfortable way to read and concentrate on the code without all the keyboard and the mouce. So I present Yomi, the missing code viewer app for iPad.

## Screenshots

Once you reach the main menu, tap on "Clone from Github" to search repositories from Github and clone it directly to your iPad.

<img src="http://i.imgur.com/G1vdfzJ.png" title="Home Screen" width="250" />
<img src="http://i.imgur.com/L6Obyw4.jpg" title="Search Github" width="250" />

You can also type a git URL directly or choose from projects that you have already cloned.

<img src="http://i.imgur.com/Yk37lnF.png" title="Manually type a git clone URL" width="250" />
<img src="http://i.imgur.com/Ygg8Z0s.png" title="Open existing projects" width="250" />

You can browse files in the cloned repository using a slidable tree-style side menu. Yomi automatically detects the programming language used for each file and highlights accordingly.

<img src="http://i.imgur.com/HM2EEkb.jpg" title="Side menu for file browsing" width="250" />
<img src="http://i.imgur.com/BDtnF6t.jpg" title="Code highlighting" width="250" />

Yomi nicely renders the README page that introduces the Git repo you've just cloned. Your code is too wide? No problem. Use Yomi in landscape mode with larger screen width.

<img src="http://i.imgur.com/lcnQmSw.jpg" title="README Markdown Rendering" width="250" />
<img src="http://i.imgur.com/LBhUzBH.jpg" title="Landscape mode" width="350" />

## Planned Features

* **Themes and Options** : Configurable syntax highlighting themes and other options 
* **Automatic File Type Detection** : Detect binary files and render images or pdf files directly.
* **Code Assist** : 'Jump to Definition', 'Find in Project' features for convenient code reading.
* **Tighter Git Integration** : Checkout from another commits/branches/tags or diff between them
* **Collaborated Code Review** : Integrate with Github/Gerrit code review tools


## Open Source Software used 

* [libgit2](http://libgit2.github.com/), a pure C git implementation and its Objective-C binding, [Objective-Git](https://github.com/libgit2/objective-git), both under MIT license
* [MFSideMenu](https://github.com/mikefrederick/MFSideMenu), slidable side menu component for iOS, BSD license
* [KOTree](https://github.com/adamhoracek/KOTree), tree component for iOS, MIT license
* [GCDWebServer](https://github.com/swisspol/GCDWebServer), a lightweight web server written in Objective-C, BSD License
* [Prism.js](http://prismjs.com), Syntax highlighter written in Javascript
* [markdown.js](https://github.com/evilstreak/markdown-js), a Markdown renderer written in Javascript
* [jQuery](http://jquery.com/), Javascript library for DOM manipulation, AJAX, etc.


## License

Yomi is a open source project and licensed under [CCL BY-NC-SA](http://creativecommons.org/licenses/by-nc-sa/3.0/).


