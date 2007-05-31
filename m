Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbXEaXWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbXEaXWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXEaXWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:22:08 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:38691 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbXEaXWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:22:05 -0400
Subject: Re: [linux-dvb] dst customization patchset
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Uwe Bugla <uwe.bugla@gmx.de>, akpm@linux-foundation.org,
       linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org
In-Reply-To: <d9def9db0705311503i3531b775p9cc226b81a547499@mail.gmail.com>
References: <20070530211826.276640@gmx.net>
	 <e0b07cc80705301808j697b816bibbbc0ed5742a69b8@mail.gmail.com>
	 <465E56AB.1000905@volny.cz> <200705311541.41710.uwe.bugla@gmx.de>
	 <d9def9db0705311503i3531b775p9cc226b81a547499@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 01:23:35 +0200
Message-Id: <1180653815.3043.11.camel@pc08.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 01.06.2007, 00:03 +0200 schrieb Markus Rechberger:
> On 5/31/07, Uwe Bugla <uwe.bugla@gmx.de> wrote:
> > Am Donnerstag, 31. Mai 2007 07:01 schrieb Bill Eldridge:
> > > timecop wrote:
> > > >>  Guys, it's GPL code. Fork the project and stop your bitching.
> > > >>  If you do a better job, people will use and contribute to your
> > version.
> > > >>  If you do a worse job, people will use and contribute to Manu's.
> > > >>  Some will use and contribute to both. Life's good, eh?
> > > >
> > > > This is exactly why Linux is shit.
> > > > You have 100s of "forked projects" because some guy named Uwe thought
> > > > he could do better than some guy named Manu and now you have two
> > > > projects to contribute to, both suck in various ways, of course some
> > > > idiot is going to be "backporting" from one to another, introducing
> > > > weird bugs, etc etc etc.
> > > >
> > > > Make a fucking decision and stick with it. Stop wasting everyone's
> > > > time. It's no secret that current Linux-DVB/V4L/whatever system is a
> > > > pile of steaming feces. Every one of you admitted to it on this list
> > > > at some point in the past. So get to it, make a fucking decision,
> > > > "fire" (loool) retards who are slowing the project down, and get shit
> > > > moving. I vote for Uwe as Linux-DVB maintainer.
> > > > Regards,
> > > > tc
> > >
> > > I nominate Timecop to be maintainer/top cop to figure out which version
> > > sucks in which area
> > > and do his best to get the best approach used. Sometimes a good strong
> > > and outspoken
> > > manager is more important than technical prowess (and I have no idea as
> > > to your technical
> > > abilities, just saying it looks like a management issue).
> >
> > I am not a fan of "strong men" or "strong managers" of whatever kind. We in
> > Germany have very bad experiences concerning this kind of human desire /
> > call
> > regarding our history.
> > Instead there should be one responsible code reviewer for v4l stuff, and at
> > least one responsible code reviewer for DVB stuff.
> > This is a minimum adequate demand to make things work.
> >
> > Inactivity on future projects in connection with Nacks of activities to
> > optimize the stock kernel are no fair play or helpful behaviour at all, but
> > they are just counterproductive. Who likes small kings? Well, I do not!
> >
> > >
> > > For Uwe, it's not that I don't "want" to understand anything - I just
> > > showed up 2 days ago and
> > > simply want a workable driver for my machine, and instead had to switch
> > > cards to something
> > > else. Usually I assume if the code was forked the fork would be
> > > somewhere else and you wouldn't
> > > be complaining to this list, but I understand there are different ways.
> > > (Samba did it this way for
> > > quite some time).
> >
> > Forking may be OK for different Linux distros. But v4l-DVB is not a distro,
> > it
> > should be a common project instead.
> >
> > What you find is some 20 developers with a multiplicity of repositories.
> > You do not even know who is maintainer and who is not.
> > What you also find is the blocking gesture of that person who once threw his
> > hat into the ring wanting to become maintainer.
> > As the whole situation is one big mess you do not even know whether becoming
> > a
> > maintainer or not is product of a democtratic vote.
> >
> > Above that there is no team structure at all, but instead there is a big
> > chaos, mess.
> > And if some code, may it be humble or mature, is not even pulled into the
> > mm-tree (its basic role has always been testing, nothing else) I would call
> > that a catastrophe.
> >
> 
> Uwe writes alot insulting crap (which is a fact), 

YES.

> even if the DVB
> subsystem has no maintainer the code should be managed appropriately
> and stopping the development is no way to do it.
> At the moment we have __tonns of critical bugs__ in the drivers and
> the video4linux and dvb framework; both frameworks are incomplete and
> don't provide the necessary flexibility to support an infrastructure
> for devices which could already be supported at the moment.
> 
> We have several (technical) good people which which work on the
> framework on different parts but who don't cooperate at all and who
> cannot work together at all.
> We have alot code which is managed in separated repositories where
> different developers spent several years of development (including
> reverse engineering, hacking and so on) it's a shame that the whole
> project is stuck where it is. New developers who fundamentally want to
> change something are not welcome at all, even if they have valuable
> ideas.
> 
> Some developers are also sick of contributing since the whole
> community is flawed at the moment. I propose a few ways to go

YES.

> * stopping that signed off by madness that every driver developer has
> to sign off changes which happened at the core which will definitelly
> never happen because people _do not like each other_.

We are forced to it.

> * change the maintainership and push it over to me, even if it sounds
> selfish at the moment _every_ code which provides additional features
> and where noone expects further improvements within the next few weeks
> (without throwing away alot of work or generating useless extra work
> by telling someone to rewrite the core of his work); everyone still
> can try to write better code - but then he _has to do it completly_
> and get in peace with the projects by supporting them to get further.

There are still gatekeepers, and they have to pay the full bill.

> The problem I have with this project is that many more things are
> upcoming at the moment (including bug fixing) but there are certain
> developers which first weren't experienced enough, afterwards started
> to think about the issues which were tried to discuss at the beginning
> already and who don't have an overview about the requirements, neither
> do they want to discuss the requirements.
> I can name numerous of bugs of this project which can be solved but
> which just get ignored. Some known bugs dont even get explained to
> people who are interested in fixing them, so this is what I consider
> that it's a major problem.

Start to name the endless bugs, align them to persons, but don't keep
them for something else you try. Get others your work done.

> I'm looking for a serious discussion about it, if anyone wants to know
> about the history I can point out to many logfiles/older emails which
> deeply explain the whole video4linux/dvb issues - the project should
> turn back to a real community.

Yes, but when the first breakage happened, I don't even know ...

Cheers,
Hermann


