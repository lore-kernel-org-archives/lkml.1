Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbXHTLSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbXHTLSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 07:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXHTLSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 07:18:23 -0400
Received: from web52505.mail.re2.yahoo.com ([206.190.48.188]:40391 "HELO
	web52505.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750908AbXHTLSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 07:18:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=6RVO/39yBrLpyOpsrqOOUplFSyC3+yHOAgJFmyG19JvD2gxEAxZKVQJjHZs/wCNjLtGj+mKTP0votMcTXiVFZEGAiAnMgTK+V0Bwp3CTte50fN74OCFgBGAoidTYix4fia+Em0VRau+POTLp7cIeKeKzsm/wtsZdQSJ+4VF9tZU=;
X-YMail-OSG: 1eACSI8VM1nhxvUE9afho3PWGIgn_60NNBDDhbgWHYTN.Z96lVLui.ocomqHoXWteNUyagRICQ50GyqULyNY9RvDzGxrcuQG4.6ZsT9hWYCULPwcVMMNDqiz0vvcKRnIrDHkjAt1KJ_ntRw-
Date: Mon, 20 Aug 2007 04:18:21 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Brennan Ashton <comphappy@gmail.com>, Nix <nix@esperi.org.uk>
Cc: Marc Perkel <mperkel@yahoo.com>, Al Viro <viro@ftp.linux.org.uk>,
       Kyle Moffett <mrmacman_g4@mac.com>, Phillip Susi <psusi@cfl.rr.com>,
       Michael Tharp <gxti@partiallystapled.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <b2d05de20708200047s6da64412tf6c5afc0b8dea540@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <465458.84259.qm@web52505.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Brennan Ashton <comphappy@gmail.com> wrote:

> While i highly support innovation, until i see a
> well layed out
> structure of what exactly you are looking for i have
> a hard time
> expressing any view that are meaningful, could you
> create some kind of
> wiki or summery email (if this is really this
> important to you) most
> of us are lazy and have better things to do, make it
> easy for us.
>   A) Create a list of the current problems or just
> inefficiencies in
> the current system.
>  B) Create a list of all the points that make up
> your view of a good
> file system.
>  C) Cross the two lists showing how your idea would
> fix the current problems.
> 
> I am not saying that the current way is the right or
> wrong way, just
> that i think you have organised your ideas as if you
> are thinking out
> loud by email (which is ok by me, just stop the
> direct attacks if you
> are).
> I agree that every company and program gets caught
> in a rut, that does
> not conform to changing markets and technology,
> especially if it was
> at one time a success, IBM, Microsoft, Apple, Sun,
> American Auto
> Industry to name a few. These are also example
> companies that have
> gotten the idea that what they do might not be right
> way and have made
> some attempt to step back (some more successfully
> than others) or face
> loss in market share.
> Just remember a key point when rethinking something
> as key as a file
> system, while your new battery may be much more
> efficient than my old
> AA, i want it to work with my old flashlights too
> (and no aftermarket
> refit kit).
> Should the surroundings be modified for the target,
> or the target
> modified for the surroundings?
> Your little rants about VI and rm are not helpful,
> if these programs
> were so bad then why have they survived. Linux is on
> hell of a project
> to be put together, sorry but innovation did come
> from people using VI
> and Emacs. btw i highly recommend the command man,
> you should try it.
> -- 
> Brennan Ashton
> Bellingham, Washington
> 
> "The box said, 'Requires Windows 98 or better'. So I
> installed Linux"
> 

What's the point? People are openly hostile to new
ideas here. I started out nice and laid out my ideas
and you have a bunch of morons who attack anything
new.

At least finally someone fixed the RM problem. 

Look at the reality of the situation. Linux is free
and yey it can't compete with operating systems that
are paid for. Maybe the reason is that when someone
point out the something is broken all yopu get is
justification and excuses and insults.

Read the thread from the beginning and you'll see that
I started out that way. 

If you attack people who are pointing out flaws and
making suggestions then people will stop pointing out
flaws and making suggestions.

Think about it. Why did it take 20 years for Linux to
fix the RM problem? If you type RM * you expect the
files to be gone, not some stupid error that I'm
trying to delete too many files.

So who's fault is that? I say it's a problem with
Linux culture. If something is broken you have to
justify it instead of fixing it.

If developers take that kind of attitude then progress
stops.

You guys are trying to may the RM problem MY FAULT
because I didn't say it nicely. We'll it doesn't have
to be said nicely. If something is broken then it
needs fixed regardless of who and how it is pointed
out.

A BUG is a BUG is a BUG. You fix bugs, not make
excuses and try to explain it away. If you went up to
any computer user and asked them if when they type "rm
*" that they expect the files to be deleted they will
say "yes". Yet in the Linux work the command doesn't
work. And it's not like it breaks after MILLIONS of
files. It breaks on just a few thousand files, if
that.

So wat does it tell you when something like this is
left broken for so long? What it tells me is that the
development process is broken.

My rant on VI is to make a point. That point being
that when you use an editor that totally sucks then
it's going to cause you to write code that sucks. It
going to lower your standards. It's going to create a
culture where poorly done work is considered
acceptable. When you use an editor as poor as vi then
the idea that rm * doesn't work becomes acceptable and
justifiable, as demonstrated here by people who
ACTUALLY DEFENDED IT.



Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Shape Yahoo! in your own image.  Join our Network Research Panel today!   http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 


