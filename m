Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbZJFUjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbZJFUjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbZJFUjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:39:06 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:54151 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbZJFUjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:39:05 -0400
Subject: Kernel Podcast Update
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 06 Oct 2009 16:38:46 -0400
Message-Id: <1254861526.3641.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Reports of its demise were greatly exaggerated. But it's going to be a
few days before we're back in sync with "current time" - I wanted to get
the retrospective episodes on the merge window done, even though it's
"old" now because the merge window period is of high value. I've been
doing about 3 hours a night over the past few days to get through it. I
view it as some kind of oddly exciting psychological masochism.

How you can help
----------------

Anyway. I would like to switch to a nice CMS to get a collaborative
effort going, sort of "firehose" style where I can post the text as it's
being worked on and others can vote/offer new text/revisions to each
story. Not exactly a wiki, but there's probably some solution I should
look at that's already out there. Advice would be welcome off list. I
really like the idea of making it really easy for people to write a
paragraph of text and propose it, since that might actually work. If
it's really easy to do, maybe people will start writing snippets.

Feed me content!
---------------

Did you just invent something really cool in the way of a patch that
everyone should hear more about? I would like to have 30-60 second
"filler" tracks to insert between segments in the show. I have recorded
a few already and will begin feeding these in once we are up to date. If
you see me at a conference, please volunteer to record something about
whatever you're working on if you think it will be helpful to others.

Overall status
--------------

As it stands, I've had precisely nobody offer to help produce the
podcast, though I do continue to get requests to add more and more
features that take time (that would be why I'm not ignoring you if you
suggest I go provide links to every patch, etc. but I just don't have
the time to actually do that). I personally don't know how Jon Corbet
manages to produce something like LWN every week - and I don't aspire to
be LWN anyway, but I do think it's cool to know everything that is
happening in the community and be as informed as humanly possible.

Each episode takes about an hour from start to finish (assuming optimal
conditions of blazing 80s power music in both ears - this activity has
replaced watching TV and other wasteful endeavors as the main thing I do
on the evening when I'm done with reading my newspaper). For those who
wonder what actually happens, here you go:

0). Grab a lot of coffee (BLOC11, 1369, Diesel Cafe), crank up some
extreme 80s power ballads - only the worst possible music.
1). Read/skim almost every mail for a given day on LKML. I switched to
using vim for this purpose although briefly was using a graphical client
so that I could have 50-100 windows open at a time and correlate stuff.
I typically read bits of LKML during the day anyway, but this is a
dedicated effort to make sure I haven't missed anything - also lets me
find things of relevance to work stuff and forward mails to people.
2). Research a few topics if they are not obvious/look at patches. I
like to know everything, but unfortunately don't, so some things require
a bit of LWN/Wikipedia/LKML research before I understand them enough. It
helps if the poster provides enough intro summary - which people have
gotten really good at in recent times - to help my poor head.
3). Pick out the major topics and make them "stories", remove minor
drivers and non-important updates, add remainder to summary. If it's
quirky and interesting, and not been covered before, it goes in.
4). Write the transcript using boilerplate text in vim.
5). Record the text into audacity (ensure PA disabled).
6). Edit the raw multitrack recording, apply volume normalizing
"compression" effect, and export as a wav file.
7). Encode with lame (highest compression quality), attach the
transcript as a comment in the style suggested by mdomsch (thanks!).
8). Manually add the episode to libsyn.com, and check the stats for
previous podcasts - I expect to hit around 100K downloads before the end
of the year, and that's not too bad for something as dry as this topic!
9). Manually edit podcast XML feed (none of the existing tools out there
that claim to do podcast friendly feeds I tried actually do something
that someone's podcasting tool won't balk at - including iTunes)
10). Post the transcript up to the website, which syncs Twitter.

If someone wanted to help me work on some scripts to make this a bit
easier, that would be awesome. It's one of these things where scripts
would save time overall but take a lot of time to get right.

Later,

Jon.

P.S. There will be a new "theme song" in due course. My girlfriend is a
film composer so I hope to have a really bad 80s power ballad or rap
song - something horrifically fun - once we get around to it.
Suggestions for really silly lyrics are welcome. I hope to take a few
courses with the local community TV station in due course with a bent
toward radio production, to see if I can improve the quality. I use
"studio" rated equipment, but there is work to be done.


