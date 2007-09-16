Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbXIPTHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbXIPTHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXIPTHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:07:34 -0400
Received: from mail.pro-g.com.tr ([81.214.24.101]:59000 "EHLO
	mail.pro-g.com.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbXIPTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:07:33 -0400
X-Greylist: delayed 1234 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Sep 2007 15:07:33 EDT
Message-ID: <46ED7A8F.1020304@pro-g.com.tr>
Date: Sun, 16 Sep 2007 11:48:47 -0700
From: "Can E. Acar" <can.acar@pro-g.com.tr>
User-Agent: Thunderbird 2.0.0.5 (X11/20070729)
MIME-Version: 1.0
To: misc@openbsd.org, linux-kernel@vger.kernel.org
CC: Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 September 2007 15:23:25 Daniel Hazelton wrote:
> On Sunday 16 September 2007 05:17:53 J.C. Roberts wrote:
>> On Sunday 16 September 2007, Jeff Garzik wrote:
>> > J.C. Roberts wrote:
>> > > http://marc.info/?l=linux-wireless&m=118857712529898&w=2
>> >
>> > Link with outdated info.
>> >
>> > > http://madwifi.org/browser/branches/ath5k
>> >
>> > Link with outdated info.
>> >
>> > > I suggest actually taking the time to get the facts before making
>> > > completely baseless statements. When you make obviously erroneous
>> > > statements, it leaves everyone to believe you are either hopelessly
>> > > misinformed, or a habitual liar. -Which is it?
>> >
>> > Please take a moment to understand the Linux development process.
>> >
>> > A better place to look would be 'ath5k' branch of
>> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.g
>> >it
>> >
>> > but nonethless, the fact remains that ath5k is STILL NOT UPSTREAM and
>> > HAS NEVER BEEN UPSTREAM, as can be verified from
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>> > 	(official linux repo; nothing is official until it hits here)
>> >
>> > Part of the reason why ath5k is not upstream is that developers are
>> > actively addressing these copyright concerns -- as can be clearly
>> > seen by the changes being made over time.
>> >
>> > So let's everybody calm down, ok?
>> >
>> > Regards,
>> >
>> > 	Jeff
>>
>> Jeff,
>>
>> Look at what you are saying from a different perspective. Let's say
>> someone took the linux kernel source from the official repository,
>> removed the GPL license and dedicated the work to public domain or put
>> it under any other license, and for kicks back-dated the files so they
>> are older than the originals. Then they took this illegal license
>> removal copy of your code and put it in a public repository somewhere.
>>
>> You'd be perfectly content with such a development because it had not
>> been officially brought "upstream" by the "offical" public domain or
>> whatever project?
> 
> But that isn't the situation being discussed. You've sent this mail to the 
> *LINUX* *KERNEL* ML, not the MadWifi ML. The patches in question were not 
> accepted into the Linux Kernel, so this is *NOT* the place to send mail 
> related to them.

You are so cleanly isolating and cutting away of a group of developers.
I sincerely hope your fellow developers will not cut you off if you
make a similar mistake. I know mine wont.

What you are saying is, a Copyright violation done by someone else is
Somebody Else's Problem (tm). There are a couple of issues with this point
of view:

First, these developers got questionable advice from senior Linux kernel
developers, and SLFC (which is closely related to FSF) in the process.

There have been complete silence from the leaders of their own
community (Linux Kernel developers, FSF, ...) all perhaps used your
argument to convince themselves that this is not their problem.
However, from an outsider point of view, this lack of silence means
an agreement to something that is ethically and legally wrong.

Furthermore, this is a case about collaboration and cooperation
between GPL and BSD developers. I believe they share some common goals
related to freedom and improvement of Open Source software.

This case illustrates some important issues that should interest ALL
free software developers:

1) How tricky code sharing between different projects can be even when
   intents and goals are pretty much alike.

2) MANY developers on BOTH sides have NO clue about the  laws and ethics
   associated with handling Copyrights and Licenses.

3) The copyrights and licenses are the foundations of our work.
   We put out great usually volunteer work, to create and improve.
   The licenses specify the terms and conditions under which we allow
   our work to be used. When we allow ANY license violation to occur,
   it affects our own work, regardless of the license on it.


> *PLEASE* go do a Google search or check the MadWifi site for their discussion 
> list/forum/whatever and complain there.

This has been done. Really. They have been contacted privately
before the issue became public. Got no results. The issue is then made
public,
with the results you see now. This is no longer a MadWifi problem.


>> No, you would most likely be absolutely livid and extremely vocal
>> getting the problem fixed immediately, so your reasoning falls apart.
> 
> Yes, true, but you are attacking people who haven't done anything wrong. And 
> by your own words, Mr. Roberts, OpenBSD has violated peoples 
> copyrights: "Most of us are also aware of the instance where OpenBSD took 
> some GPL code and replaced the license with BSD. What OpenBSD did in that 
> cases was just as illegal,"

Sometimes inaction is wrong.

In case of the OpenBSD Broadcom driver using parts of the GPL driver
which was
under construction and prematurely committed to a public repository, NONE
of the OpenBSD developers argued for what was done. It was illegal, and
the driver was removed immediately.

What was being debated was the approach. The OpenBSD project or the
developer
was NOT contacted privately. The issue was made public immediately, with all
the flame fest that followed.


> If the OpenBSD developers want to attack the Linux Kernel community over 
> patches that were *NEVER* *ACCEPTED* by said community, it should be just as 
> fair for the Linux Kernel community to complain about those (unspecified) 
> times where OpenBSD replaced the GPL on code with the BSD license.

It is fair. All license issues deserve utmost attention and respect by
all communities. If we let such issues to go unresolved, we face a
much greater danger to our work.

Please note that this is NOT a revenge, as some obviously think it to be.

We take our copyrights most seriously. We contacted MadWifi privately, they
did not heed our requests. We made the issue public, some senior Linux
Developers said "so what is the issue".   We trusted Eben from SLFC to set
things straight, and waited for a resolution. They instead give the
developers
questionable legal advice, and do not respond to our valid inquiries and
objections.

Is it too naive to hope that some leader/senior developer from the
Linux/FSF/GNU
whatever will take the clue stick and let the developers know what is
happening
is wrong. Being leaders in a community do have some responsibilities you
know.


> And, as said before, the place to take these complaints is the MadWifi 
> discussion area, since they are, apparently, the only people that accepted 
> the patches in question.
>
>> If the people who could fix the problem continued to ignore you, and the
>> people in leadership roles tell you then intend to steal your code,
>> then you would continue to get more angry and vocal about it.
> 
> *WE*, the people on the Linux Kernel ML, *CANNOT* "fix the problem" with the 
> *MADWIFI* code having accepted patches which violate Reyk's copyright.

*WE* the OpenBSD people *DO NOT* want you to "fix the problem". We want you
to be aware of the issues, and react responsibly. A response from the
leaders
of their own community would have a MUCH GREATER impact in ending the
discussion
and ending all the trolling.

But it appears, disowning them is a much convenient solution for most
"leaders".


>> Now take it one step further. For the sake of example, let's assume all
>> of this atheros driver nonsense went to a German court and the
>> GNU/FSF/SFLC/Linux or whoever you want to call yourselves lost a
>> criminal copyright infringement suit. You have now been legally proven
>> to be guilty code theft.
>>
>> After such a ruling let's assume some jerk was to do the all the
>> horrific stuff mentioned in the first paragraph above to the linux
>> source tree, along with a little regex magic to call it something other
>> than "linux" and seeded the Internet with countless copies. At this
>> point, the GNU, FSF, GPL and all of the hard working Linux devs are now
>> stuffed. A company could download the bogus source, violate the now
>> missing GPL license, claim you stole the code from someplace else on
>> the `net and illegally put your GPL license on it... Worst of all, they
>> now have your past conviction of criminal code theft to back up their
>> assertion about the way you normally operate.
>>
>> You should be concerned. The above is an immoral and illegal but still
>> practical attack on the GPL and all of hard work by many great people.
>> By having some people within the GNU/FSF/GPL camp indulging in code
>> theft to push their preferred license and the reasonable folks in the
>> GNU/FSF/GPL camp refusing to voice a strong opinion against code theft,
>> you are weakening your own license.
> 
> Linux Kernel != FSF/GNU
> 
> If it was then RMS would not be attacking Linus and Linux with faulty claims 
> just because Linus has publicly stated that the GPLv2 is a better license 
> than v3 and because Linux cannot, for numerous reasons, ever be released 
> under the GPLv3.
> 
> I repeat - Linux has *NOT* and will *NEVER* accept the patches in question. If 
> somebody else has, then go and yell at them about it. The developers here, on 
> the LINUX KERNEL MAILING LIST, have no control or authority (in general) over 
> projects such as MadWifi. If they have accepted the faulty patches - and said 
> patches are now part of their code-base, then go tell them about it and make 
> sure Theo gets the message.

I repeat, you do NOT have to be in control of a project to take action.

The silence means you are fine with copyright violations. It means that if,
for some reason, we stopped (or did not start) yelling, then you would
let it be.

Licenses are important and must be respected. The communities would not *be*
otherwise.

Can


-- 
In theory, there is no difference between theory and practice.
But, in practice, there is.
