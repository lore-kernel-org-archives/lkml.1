Return-Path: <linux-kernel-owner+w=401wt.eu-S1762586AbYGOSe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762586AbYGOSe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762056AbYGOSeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:34:00 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55686 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761989AbYGOSd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:33:59 -0400
Date: Tue, 15 Jul 2008 14:33:51 -0400
From: Theodore Tso <tytso@mit.edu>
To: pageexec@freemail.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
Message-ID: <20080715183351.GF8185@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, pageexec@freemail.hu,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <alpine.LFD.1.10.0807141924020.3017@woody.linux-foundation.org> <487CDEDD.21049.1ACFDAEA@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487CDEDD.21049.1ACFDAEA@pageexec.freemail.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 05:31:09PM +0200, pageexec@freemail.hu wrote:
> obviously there *is* a policy, it's just not what you guys declared
> earlier in Documentation/SecurityBugs. would you care to update it
> or, more properly, remove it altogether as it currently says:

Hi, so I'm guessing you're new to the Linux kernel.  What you are
missing is while *Linus* is unwilling to play the disclosure game,
there are kernel developers (many of whom work for distributions, and
who *do* want some extra time to prepare a package for release to
their customers) who do.  So what Linus has expressed is his personal
opinion, and he is simply is not on any of the various mailing lists
that receive limited-disclosure information, such as the general
vendor-sec@lst.de mailing list, or the security@kernel.org list
mentioned in Documentation/SecurityBugs.

Both vendor-sec and security@kernel.org are not formal organizations,
so they can not sign NDAs, but they will honor non disclosure
requests, and the subscription list for both lists is carefully
controlled.

People like Linus who have a strong, principled stand for Full
Disclosure simply choose not to request to be placed on those mailing
lists.  And if Linus finds out about a security bug, he will fix it
and check it into the public git repository right away.  But he's very
honest in telling you that is what he will do --- so you can choose
whether or not to include him in any disclosures that you might choose
to make.

The arguments about whether or not Full Disclosure is a good idea or
not, and whether or not the "black hat" and "grey hat" and "white hat"
security research firms are unalloyed forces for good, or whether they
have downsides (and some might say very serious downsides) have been
arguments that I have personally witnessed for over two decades
(Speaking as someone who helped to dissect the Robert T. Morris
Internet Worm in 1988, led the Kerberos development team at MIT for
many years, and chaired the IP SEC Working Group for the IETF, I have
more than my fair share of experience).  It is clear that we're not
going settle this debate now, and certainly not on the Linux Kernel
Mailing List.

Suffice it to say, though, that there are people whose views on these
matters span the entire gamut, and I know many reasonable people who
hold very different positions along the entire continuum --- and this
is true both in the Internet community at large, and in the Linux
Kernel development community specifically.

Best regards,

					- Ted
