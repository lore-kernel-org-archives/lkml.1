Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbXIPUcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbXIPUcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbXIPUck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:32:40 -0400
Received: from keil-draco.com ([216.193.185.50]:50001 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbXIPUcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:32:39 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Can E. Acar" <can.acar@pro-g.com.tr>
Subject: Re: Wasting our Freedom
Date: Sun, 16 Sep 2007 16:32:21 -0400
User-Agent: KMail/1.9.6
Cc: misc@openbsd.org, linux-kernel@vger.kernel.org,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr>
In-Reply-To: <46ED7A8F.1020304@pro-g.com.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709161632.21927.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 September 2007 14:48:47 Can E. Acar wrote:
> On Sunday 16 September 2007 15:23:25 Daniel Hazelton wrote:
> > On Sunday 16 September 2007 05:17:53 J.C. Roberts wrote:
> >> On Sunday 16 September 2007, Jeff Garzik wrote:
> >> > J.C. Roberts wrote:
> >> > > http://marc.info/?l=linux-wireless&m=118857712529898&w=2
> >> >
> >> > Link with outdated info.
> >> >
> >> > > http://madwifi.org/browser/branches/ath5k
> >> >
> >> > Link with outdated info.
> >> >
> >> > > I suggest actually taking the time to get the facts before making
> >> > > completely baseless statements. When you make obviously erroneous
> >> > > statements, it leaves everyone to believe you are either hopelessly
> >> > > misinformed, or a habitual liar. -Which is it?
> >> >
> >> > Please take a moment to understand the Linux development process.
> >> >
> >> > A better place to look would be 'ath5k' branch of
> >> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.g
> >> >it
> >> >
> >> > but nonethless, the fact remains that ath5k is STILL NOT UPSTREAM and
> >> > HAS NEVER BEEN UPSTREAM, as can be verified from
> >> >
> >> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> >> > 	(official linux repo; nothing is official until it hits here)
> >> >
> >> > Part of the reason why ath5k is not upstream is that developers are
> >> > actively addressing these copyright concerns -- as can be clearly
> >> > seen by the changes being made over time.
> >> >
> >> > So let's everybody calm down, ok?
> >> >
> >> > Regards,
> >> >
> >> > 	Jeff
> >>
> >> Jeff,
> >>
> >> Look at what you are saying from a different perspective. Let's say
> >> someone took the linux kernel source from the official repository,
> >> removed the GPL license and dedicated the work to public domain or put
> >> it under any other license, and for kicks back-dated the files so they
> >> are older than the originals. Then they took this illegal license
> >> removal copy of your code and put it in a public repository somewhere.
> >>
> >> You'd be perfectly content with such a development because it had not
> >> been officially brought "upstream" by the "offical" public domain or
> >> whatever project?
> >
> > But that isn't the situation being discussed. You've sent this mail to
> > the *LINUX* *KERNEL* ML, not the MadWifi ML. The patches in question were
> > not accepted into the Linux Kernel, so this is *NOT* the place to send
> > mail related to them.
>
> You are so cleanly isolating and cutting away of a group of developers.
> I sincerely hope your fellow developers will not cut you off if you
> make a similar mistake. I know mine wont.

No, I'm saying "You are complaining about this in the wrong place and accusing 
the wrong people of the misdeed."

> What you are saying is, a Copyright violation done by someone else is
> Somebody Else's Problem (tm). There are a couple of issues with this point
> of view:
>
> First, these developers got questionable advice from senior Linux kernel
> developers, and SLFC (which is closely related to FSF) in the process.

IIRC, the advice was "Yes, it is legal to choose to follow only one of 
multiple offered licenses on a project" - nothing else. They looked at the 
patches and said "Wait, you've changed the license on files that aren't under 
a dual license."

Hence, no problems here - no questionable advice only.

<snip>
>
> > *PLEASE* go do a Google search or check the MadWifi site for their
> > discussion list/forum/whatever and complain there.
>
> This has been done. Really. They have been contacted privately
> before the issue became public. Got no results. The issue is then made
> public,
> with the results you see now. This is no longer a MadWifi problem.

Then file the lawsuit - if they have violated the license and ignored requests 
to fix the problem then there is sound legal grounds for it.

<snip>
>
> > If the OpenBSD developers want to attack the Linux Kernel community over
> > patches that were *NEVER* *ACCEPTED* by said community, it should be just
> > as fair for the Linux Kernel community to complain about those
> > (unspecified) times where OpenBSD replaced the GPL on code with the BSD
> > license.
>
> It is fair. All license issues deserve utmost attention and respect by
> all communities. If we let such issues to go unresolved, we face a
> much greater danger to our work.

Yes, but in this case you are complaining to people that have no control over 
the code in question. It's known that the patches are bad, and if people 
continue to use them, then it is their problem and the problem of the 
copyright holder.

<snip>
>
> Is it too naive to hope that some leader/senior developer from the
> Linux/FSF/GNU
> whatever will take the clue stick and let the developers know what is
> happening
> is wrong. Being leaders in a community do have some responsibilities you
> know.

And it has happened - the Linux Kernel community has commented on the 
situation a *LOT* - to the extent that the patches in question were 
rejected - long *BEFORE* Theo commented on it.

> > And, as said before, the place to take these complaints is the MadWifi
> > discussion area, since they are, apparently, the only people that
> > accepted the patches in question.
> >
> >> If the people who could fix the problem continued to ignore you, and the
> >> people in leadership roles tell you then intend to steal your code,
> >> then you would continue to get more angry and vocal about it.
> >
> > *WE*, the people on the Linux Kernel ML, *CANNOT* "fix the problem" with
> > the *MADWIFI* code having accepted patches which violate Reyk's
> > copyright.
>
> *WE* the OpenBSD people *DO NOT* want you to "fix the problem". We want you
> to be aware of the issues, and react responsibly. A response from the
> leaders
> of their own community would have a MUCH GREATER impact in ending the
> discussion
> and ending all the trolling.

This has happened. Or are you ignoring the evidence in favor of more trolling 
and FUD ?

> But it appears, disowning them is a much convenient solution for most
> "leaders".

Learn to read. It has happened.

> >> Now take it one step further. For the sake of example, let's assume all
> >> of this atheros driver nonsense went to a German court and the
> >> GNU/FSF/SFLC/Linux or whoever you want to call yourselves lost a
> >> criminal copyright infringement suit. You have now been legally proven
> >> to be guilty code theft.
> >>
> >> After such a ruling let's assume some jerk was to do the all the
> >> horrific stuff mentioned in the first paragraph above to the linux
> >> source tree, along with a little regex magic to call it something other
> >> than "linux" and seeded the Internet with countless copies. At this
> >> point, the GNU, FSF, GPL and all of the hard working Linux devs are now
> >> stuffed. A company could download the bogus source, violate the now
> >> missing GPL license, claim you stole the code from someplace else on
> >> the `net and illegally put your GPL license on it... Worst of all, they
> >> now have your past conviction of criminal code theft to back up their
> >> assertion about the way you normally operate.
> >>
> >> You should be concerned. The above is an immoral and illegal but still
> >> practical attack on the GPL and all of hard work by many great people.
> >> By having some people within the GNU/FSF/GPL camp indulging in code
> >> theft to push their preferred license and the reasonable folks in the
> >> GNU/FSF/GPL camp refusing to voice a strong opinion against code theft,
> >> you are weakening your own license.
> >
> > Linux Kernel != FSF/GNU
> >
> > If it was then RMS would not be attacking Linus and Linux with faulty
> > claims just because Linus has publicly stated that the GPLv2 is a better
> > license than v3 and because Linux cannot, for numerous reasons, ever be
> > released under the GPLv3.
> >
> > I repeat - Linux has *NOT* and will *NEVER* accept the patches in
> > question. If somebody else has, then go and yell at them about it. The
> > developers here, on the LINUX KERNEL MAILING LIST, have no control or
> > authority (in general) over projects such as MadWifi. If they have
> > accepted the faulty patches - and said patches are now part of their
> > code-base, then go tell them about it and make sure Theo gets the
> > message.
>
> I repeat, you do NOT have to be in control of a project to take action.
>
> The silence means you are fine with copyright violations. It means that if,
> for some reason, we stopped (or did not start) yelling, then you would
> let it be.

No, I'm not. In fact, I don't use MadWifi, endorse it or even like it. I even 
advise people *NOT* to use it. Or is that *NOT* enough for you?

DRH


-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
