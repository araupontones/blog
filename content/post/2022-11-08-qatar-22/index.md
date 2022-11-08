---
title: 'Qatar 2022: match predictor'
author: ''
date: '2022-11-08'
slug: qatar-22
categories: []
tags: []
---

Every four years, a group of friends organize a World Cup pool (a ["Quiniela"](https://cariquiniela.com/inicio)). The price of winning it is huge. However, for the last four World Cups my performance has been rather pathetic. The reason: I drew my scores based on emotions (In my last pool, Mexico made it to semis...).

Recently, I visited a friend Oslo who is an expert in Machine Learning and Deep Generative Models. He's also a big fan of football. Over a couple of beers, quite a few, we decided to unite my data carpentry skills with his statistical knowledge to try to predict Qatar's WC matches. And if possible, become, for the first time, the winners of the "Cari Quiniela".

See all the code in [GitHub](https://github.com/araupontones/CariQuiniela).

# This is what we did

1. We first web-scrapped, from [fbref](https://fbref.com/en/), all the matches that the 32 qualified teams have played since 2011 until just before the WC. 
2. To have a proxy for each team's performance index, we requested (via [odds-API](https://the-odds-api.com/)) the odds of each team to win the WC. Because the odds are dynamic, we created a scheduled job in our virtual machine to update the odds on daily basis. 
3. We assumed that, among other things, the number of goals that each team is expected to score during a match, is a function of the number of goals that they have scored in the past, the number of matches that they have failed to score, and the skills of the team that they are playing against. Thus, we created a summary table with these indicators for each team and all years since 2011.
4. During the World Cup, we defined a scheduled job (a cron-job) to update our indicators on daily basis. Thus, our data was always up-to-date.
5. Then, my friend did his predictive magic.

![](https://media.tenor.com/t4HIrZDwx8AAAAAS/doc-brown-it-works.gif)

# What was the result?

... wait until the WC ends



# Some code tips to replicate a similar job

## Avoid GitHub asking for credentials everytime 

It is important to **clone the repo in your virtual machine using "SSH"**. By doing this, you avoid git asking for credentials every time. To do that:


[Cameron McKensie's]("https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/GitHub-SSH-Key-Setup-Config-Ubuntu-Linux"") tutorial was very useful for this.

* In your terminal, check that you don't have any ssh keys installed yet in /user/.ssh/
* If there are none ssh keys, generate one
* `ssh-keygen -o -t rsa -C "mail@myemail.com"`
* It will create a .pub and private key in /user/.ssh/
* Open .pub with notes and paste it in your ssh keys in Settings  >SSh and GPG keys  
* Copy these keys in your virtual machine under /root/.ssh 
* Now clone the repo to your virtual matchine 



## Create a schedule task using crontab

[This tutorial](https://phoenixnap.com/kb/set-up-cron-job-linux) and this [Wiki Article](https://en.wikipedia.org/wiki/Cron) describe the step by step to schedule a job in your virtual machine

* Basically, on your terminal, open the crontab editor `crontab -e`
* And define the command to be run: `* * * * * /your_directory/your_command`


