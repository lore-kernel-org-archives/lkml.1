Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbXHWLFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbXHWLFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbXHWLFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:05:32 -0400
Received: from thunk.org ([69.25.196.29]:59379 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbXHWLFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:05:32 -0400
Date: Thu, 23 Aug 2007 07:05:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Morris <jmorris@namei.org>, Dave Jones <davej@redhat.com>,
       Tech Board Discuss 
	<Tech-board-discuss@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Tech-board-discuss] Re: Linux Foundation Technical Advisory Board Elections
Message-ID: <20070823110521.GI7267@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>, Dave Jones <davej@redhat.com>,
	Tech Board Discuss <Tech-board-discuss@lists.linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1187796179.3410.32.camel@localhost.localdomain> <20070822212202.GE17546@redhat.com> <1187819038.3410.114.camel@localhost.localdomain> <20070822215816.GG17546@redhat.com> <1187820866.3410.129.camel@localhost.localdomain> <20070823021204.GF7267@thunk.org> <Xine.LNX.4.64.0708221924070.14411@us.intercode.com.au> <1187840997.3410.160.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187840997.3410.160.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 10:49:57PM -0500, James Bottomley wrote:
> Then you're misconstruing the interactions.  A representational role
> would imply the ability to speak for the community and make promises on
> its behalf.  That, as Ted has already said, can't happen.  Instead, the
> value to the LF is that the TAB contains people experienced in community
> interactions who can act as a sounding board for what may (or may not)
> be well received.

One thing that may be helpful for people to understand is that serving
on the TAB is more a matter of service than anything else.  There are
relatively few benefits of actually being on the TAB.  Sure, you may
be more likely to get a free trip to Japan to talk about what's going
on in kernel development and to help some of the Japanese developers
being employed by the Japanese member comapnies become more effective
contributors to Linux and the LKML.  But, the sort of people that
serve on the TAB generally travel too much already, and there has
already been talk about trying to get more people outside of the TAB
who are interested in serving in this role to have a chance to go to
the LF Japan Linux Symposium.

And sure, the TAB members have a bit more direct ability to make
suggestions about how various LF programs that directly benefit the
Linux community will be managed --- but the flip side of that is there
are monthly concalls and documents to review, and for the chair of the
TAB (currently James), the responsibility to sit on day-long,
face-to-face OSDL (and now Linux Foundation) board meetings.  This
last is important, since many of the other members of the board are
from companies that are contributing large sums of money to the LF,
which means they are generally VP's and General Managers.  Those folks
are generally not technical at all, and are so far removed from the
kernel community that they have no idea how to help the kernel
community or even if certain proposals or initiative that they might
try out would be well received.

OSDL, to its credit (and those of you who know me know that I was
often very critical of the OSDL, in part because its leadership and
management was so badly disconnected from community concerns), FINALLY
realized this was a problem in recent years, and so the TAB was the
first attempt to try to solve this problem.

An SPI-like or Debian-like approach with pure democracy might look
good on paper, but when you have companies donating hundreds of
thousands of dollars and up to the organization, having a board which
is elected by mobs of GPLv3 groupies would understandably scare them.
So we need some way of selecting the kernel developers who are willing
to invest the time to help the LF do the right thing with the
resources that they have been given.  One way of doing this would be
to have someone from the LF just pick the obvious candidates; the
problem with that is that it would be rightly viewed as cronyism.
Another way would be to have a membership committee that selected
people who are considered true members of the kernel development
community, and then let them vote.  But that's a rather heavyweight
solution, and if could result in all sorts of hard feelings about who
is and isn't allowed to vote.

Having the election at the KS was basically a lightweight way of doing
this, although I would have to admit that the pool of electors is a
much smaller than my liking.  If the TAB was able to make promises on
behalf of the community, or enter into deals that bound the
community[1], or if it controlled a significant monetary budget, then
we would probably need a much more heavyweight and rigorous election
process.

But, as other people have said, patches are welcome.  Feel free to
suggest other ways in which this could be done, keeping in mind our
design constraints.

						- Ted

[1] Which at one point the FSF was hoping they could do during the
GPLv3 discussions.  We very quickly set them straight that while the
TAB could talk about concerns that we as individuals had and talk
about concerns that had been expressed on the LKML, there was no way
that the TAB could negotiate any kind of quid pro quo on behalf of the
community; and thus we could not represent the kernel community in
that sense of the word.  The only way in which the TAB is
"representational" is in the sense of the word "representative
sample"; the LF leadership team can't talk to every single kernel
developer, so it needs to find a what is hopefully a representative
sample of kernel developers, who are also willing to put in the time
and effort to help the LF succeed.
