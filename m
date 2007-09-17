Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbXIQHgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbXIQHgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 03:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbXIQHgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 03:36:38 -0400
Received: from keil-draco.com ([216.193.185.50]:50796 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbXIQHgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 03:36:37 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Can E. Acar" <can.acar@pro-g.com.tr>
Subject: Re: Wasting our Freedom
Date: Mon, 17 Sep 2007 03:36:25 -0400
User-Agent: KMail/1.9.6
Cc: misc@openbsd.org, linux-kernel@vger.kernel.org,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <200709170133.17025.dhazelton@enter.net> <46EE2226.2090203@pro-g.com.tr>
In-Reply-To: <46EE2226.2090203@pro-g.com.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709170336.26289.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2007 02:43:50 Can E. Acar wrote:
> Daniel Hazelton wrote:
> > On Sunday 16 September 2007 23:00:09 Can E. Acar wrote:
>
> [snip]
>
> >> Theo summarized the latest situation here, some days ago:
> >>
> >>   http://marc.info/?l=openbsd-misc&m=118963284332223&w=2
> >>
> >> and here is a very brief summary:
> >>
> >>   http://marc.info/?l=openbsd-misc&m=118965266709012&w=2

BTW, I didn't say anything the last time, but the above mail is a load of 
horse-shit. Theo is pointing fingers and making claims that anyone capable of 
independent thought can see aren't related to reality.

Quoted in full (my comments are in the curly-braces):

I recognize that writeup about the Atheros / Linux / SFLC story is a
bit complex, so I wrote a very simple explanation to someone, and they
liked it's clarity so much that they asked me to post it for everyone.
Here it is (with a few more changes)

{Okay, this starts off good. Theo is going to make sure people understand what 
is going on and what has happened. Perhaps he has realized things are 
different from when he claimed that people were being advised to break the 
law.}

-----
starting premise:
 
   you can already use the code as it is

steps taken:

1. pester developer for a year to get it under another license.
   - get told no, repeatedly

{Alright - not a problem here. Happens all the time}

2. climb over ethical fence

{Off the deep end already, but lets keep going...}

3. remove his license
   - get caught, look a bit stupid

{Caught? Well, yeah. Caught by the Linux Kernel developers before it became a 
real problem. This has been fixed, although the code still hasn't been added 
to the core Kernel tree - and the current iteration still hasn't been offered 
for review}

4. wrap his license with your own
   - get caught, look really stupid

{Not done, although this was, apparently, suggested by the SFLC. Nice FUD 
there, Theo.}

5. assert copyright under author's license, without original work
   - get caught, look even more stupid

{Not done. Again, nice FUD there}

Right now the wireless linux developers -- aided by an entire team of
evidently unskilled lawyers -- are at step 5, and we don't know what
will happen next.  We wait, to see what will happen.

{Theo, embrace reality. It'll solve all kinds of problems. It's a simple fact 
that reality has split from Theo's view of things between numbers 3 and 4. 
What has happened is that the licenses have been maintained and the two 
people that have been working on it for the Linux kernel has added their own 
copyrights - covering the code they have added. If someone outside the Linux 
Kernel development team has followed the above path then there is no reason 
to doubt that they have created problems for themselves.}

Reyk can take them to court over this, but he must do it before the
year 2047.

{While there are ways to handle the situation that don't involve lawsuits I 
don't think this is the best solution. I don't know what avenues that Reyk 
and the OpenBSD community have already tried, but from what I've been told 
all that's been done is a "private" message to the MadWifi people that they 
are violating a copyright. The rest has been flames and FUD on the Linux 
Kernel ML - which solves nothing and just creates problems. Maybe if the 
OpenBSD community slammed the MadWifi mailing lists over this instead of the 
Linux Kernel ML the problem there would go away...}

> >> If you really want to know the latest situation, please read these
> >> links, and think about it.
> >
> > No need. Here are the facts:
>
> It is now obvious that you have no interest in facts,
> You blindly repeat what you made yourself to believe.

I believe the truth. All the facts I have are derived from the mail exchanges 
I've witnessed. If you disagree with the facts as I understand them say so - 
don't just say that I'm "making myself believe them". If I've made a mistake 
in judging the facts from available evidence then let me know - and provide a 
reference that shows where I made the mistake. (ie: a public e-mai, etc...)


Anyway...

The facts I stated could be shown from the LKML archives, but I believed you'd 
have seen the same posts I have - almost all the relevant posts were in 
threads that were CC'd to at least one of the OpenBSD ML's.

I dissected the logic presented and pointed out how *ALL* the arguments that 
have been presented so far have been either handled - either by being shown 
to be false or in the most logical (and legal) manner possible. But instead 
of the most expected answer - that is, attacks on the core Linux Kernel 
developers - ie: those that discuss development and exchange patches on LKML 
stopping - Theo continues to stir up the trouble by claiming that *ALL* Linux 
Kernel developers are making a concentrated attempt to "steal" code.

That is sheer and utter bullshit. I've finished a quick look through the 
Atheros code in the git repo that Theo pointed out and don't see how 
his "Just an Adaptation" argument works - there is more than enough new stuff 
in all the files for those portions to qualify for a new copyright. 
(although, truthfully, I think it should say "Portions Copyright xxx" and not 
just a blanket statement - that *MIGHT* be what Theo is referring to...)

If the people working on the MadWifi project (the first two links in Theo 
posted) have violated Reyk's copyright, then go after them. Flame their 
mailing list(s) and bug them. And yes, I have been told that they 
were "Privately Approached" - but that isn't what has been done here. You, 
Theo and every other person that has spammed and flamed LKML over it don't 
seem to understand one simple fact: MadWifi != Linux Kernel

As I've stated before - I don't use MadWifi, won't do a Linux install that 
uses it and I make sure to tell everyone that asks about it not to use it. 
Why? Well, for one I have never trusted it to be clear of problems like this 
one and the other reason is - If it's so good, why haven't the developers 
attempted to get it in the kernel?

Now, as I've said, I have only done a quick comparison of the "wireless-dev" 
git tree and the Atheros code found in src/sys/dev/ic/ in the OpenBSD CVS 
tree. So far I am still a bit unsure as to whether there is enough new code 
to qualify for a copyright (the dozens of misc. changes and code reformatting 
creates a lot of noise) but so far I'm pretty certain that the added stuff 
does, in general, qualify. (IANAL and I'm not going to even guess what a 
random court might think is "enough" - but my personal thought about "enough" 
is more than 30 lines of code)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
