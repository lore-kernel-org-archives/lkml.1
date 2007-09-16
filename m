Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbXIPUdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbXIPUdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbXIPUdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:33:42 -0400
Received: from THUNK.ORG ([69.25.196.29]:41004 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbXIPUdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:33:41 -0400
Date: Sun, 16 Sep 2007 16:33:16 -0400
From: Theodore Tso <tytso@mit.edu>
To: "J.C. Roberts" <jcroberts@designtools.org>
Cc: Jeff Garzik <jeff@garzik.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Jason Dixon <jason@dixongroup.net>, misc@openbsd.org,
       moglen@softwarefreedom.org, lessig_from_web@pobox.com,
       bkuhn@softwarefreedom.org, norwood@softwarefreedom.org,
       fontana@softwarefreedom.org, karen@softwarefreedom.org,
       linux-kernel@vger.kernel.org
Subject: Re: Wasting our Freedom
Message-ID: <20070916203316.GB5502@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"J.C. Roberts" <jcroberts@designtools.org>,
	Jeff Garzik <jeff@garzik.org>, Kyle Moffett <mrmacman_g4@mac.com>,
	Jason Dixon <jason@dixongroup.net>, misc@openbsd.org,
	moglen@softwarefreedom.org, lessig_from_web@pobox.com,
	bkuhn@softwarefreedom.org, norwood@softwarefreedom.org,
	fontana@softwarefreedom.org, karen@softwarefreedom.org,
	linux-kernel@vger.kernel.org
References: <5C8C3794-C62A-4935-8267-81080CCF6867@dixongroup.net> <200709160052.45493.jcroberts@designtools.org> <46ECE554.5030308@garzik.org> <200709160217.55933.jcroberts@designtools.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709160217.55933.jcroberts@designtools.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 02:17:53AM -0700, J.C. Roberts wrote:
> Look at what you are saying from a different perspective. Let's say 
> someone took the linux kernel source from the official repository, 
> removed the GPL license and dedicated the work to public domain or put 
> it under any other license, and for kicks back-dated the files so they 
> are older than the originals. Then they took this illegal license 
> removal copy of your code and put it in a public repository somewhere.

Ok, suppose someone did (precisely) this.  Then the person to be upset
with would be the people who did this, not the people behind the
official repository.  Some folks seem to be unfortuntaely blaming the
people who run the official repository.  

Look, it's perhaps a little understandable that people in the *BSD
world might not understand that the Linux development community is
huge, and not understand that the people who work on madwifi.org, the
core kernel community, and the FSF, are distinct, and while they might
interact with each other, one part of the community can't dictate what
another part of the community does.  You wouldn't want us to conflate
all of the security faults of say, NetBSD with OpenBSD, just because
it came from a historically similar code base and "besides all you
*BSD folks are all the same --- if you don't want a bad reputation,
why don't you police yourselves"?  Would you not say this is
unreasonable?  If so, would you kindly not do the same thing to the
Linux community?

Secondly, it looks like people are getting worked up about two
different things, and in some cases it looks like the two things are
getting conflated.  The first thing is a screw-up about attribution
and removal of the BSD license text, and that is one where the SFLC
has already issued advice that this is bad ju-ju, and that the BSD
license text must remain intact.

The second case which seems to get people upset is that there are
people who are taking BSD code, and/or GPL/BSD dual licensed code, and
adding code additions/improvements/changes under a GPL-only license.
This is very clearly legal, just as it is clearly legal for NetApp to
take the entire BSD code base, add proprietary changes to run on their
hardware and to add a propietary, patent-encrusted WAFL filesystem,
and create a codebase which is no longer available to the BSD
development community.

The first case was clearly a legal foul, whereas the second case is
legally O.K (whether the GPL or NetApp propietary license is
involved).  However, people are conflating these two cases, and using
words like "theft" and "copyright malpractice", without being clear
which case they are talking about.  If we grant that the first is bad,
and is being rectified before it gets merged into the mainline kernel,
can we please drop this?  If you are truely offended that working
pre-merge copies of the files with the incorrect copyright statements
still exist on the web, feel free to send requests to madwifi.org, the
Wayback Archive, and everywhere else to stamp them out --- but can you
please leave the Linux Kernel Mailing List out of it, please?

As far as the second case is concerned, while it is clearly _legally_
OK, there is a question whether it is _morally_ a good idea.  And this
is where a number of poeple in the Linux camp are likely to accuse the
*BSD people who are making a huge amount of fuss of being hypocrites.
After all, most BSD people talk about how they are *proud* that
companies like NetApp can take the BSD code base, and make
improvements, and it's OK that those improvements never make it back
to the BSD code base.  In fact, these same *BSD folks talk about how
this makes the BSD license "more free" than the GPL.  

Yet, when some people want to take BSD code (and let's assume that
proper attributions and copyright statements are retained, just as
I'll assume that NetApp also preserved the same copyright statements
and attributions), and make improvements that are under the GPL, at
least some *BSD developers are rising up and claiming "theft"!  Um,
hello?  Why is it OK for NetApp to do it, and not for some Linux
wireless developers to do precisely the same thing?  Is it because the
GPL license is open source?  At least that way you can see the
improvements (many of them would have been OS-specific anyway, since
the BSD and Linux kernel infrastructures are fundamentally different),
and then reimplement yourself ---- in the case of NetApp, you don't
even get to **see** the sources to the WAFL filesystem; they are,
after all, under a proprietary copyright license.

The final argument that could be made is the practical one; that
regardless of whether or not a Linux wireless developer has any legal
or moral right to do what NetApp developers have done years ago, that
it would be better to cooperate.  That's a judgement call, and I'll
assume that the BSD wireless developers are different from the people
who are screaming and trolling on the kernel mailing list --- since if
there is any overlap between the whiners and kvetchers who have been
invading the LKML, it would seem pretty clear that cooperating with
such a bunch lusers is probably more trouble than it's worth.  But
just as it's not fair to judge Linux developers by the more immature
Slashdot kiddies/fanboys, we can't assume that the people who have
been whining and shooting off their mouth about theft are not
representative of the *BSD developers.  

So if we disregard that issue, the practical reality is that BSD and
Linux are different.  While the madwifi drivers were outside of the
tree, it might have made sense to have an OS-independent layer and
then surround the driver with an OS abstraction layer.  But if the
driver is going to be merged with mainline, the general Linux practice
is to make those abstraction layers Go Away.  (There have been a few
exceptions, such as the hideous Irix/vnode #define compatibility mess
in XFS, but that's been gradually cleaned up, and it really is the
exception that proves the rule; it's a great demonstration about why
such abstraction layers make the code less maintainable, and less
readable.)  Once you remove the OS abstraction layer, the code wasn't
going to be very useful to a BSD-based kernel _anyway_, so in
practical matters, whether the code would continue to be dual-licensed
GPL/BSD wouldn't matter anyway.

Hopefully this adds some clarity to the matter.

Regards,

						- Ted
