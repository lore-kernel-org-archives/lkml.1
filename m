Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYE3Ur6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYE3Ur6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYE3Urt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:47:49 -0400
Received: from 1wt.eu ([62.212.114.60]:1355 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYE3Urt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:47:49 -0400
Date: Fri, 30 May 2008 22:46:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How many contributors are we losing
Message-ID: <20080530204621.GD5609@1wt.eu>
References: <20080528225136.GA29014@kroah.com> <1FE6DD409037234FAB833C420AA843EC016FFF69@orsmsx424.amr.corp.intel.com> <20080529003657.GA17505@kroah.com> <20080529010055.GA31952@redhat.com> <20080529022632.GB5180@kroah.com> <1FE6DD409037234FAB833C420AA843EC017405EB@orsmsx424.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC017405EB@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 01:23:44PM -0700, Luck, Tony wrote:
> Greg wrote:
> > I also have "cleaned up" versions of the kernel log files for just the
> > reason you say above.  You would not believe the number of times some
> > people mispell their own name in a single kernel release...  That makes
> > it easier to do this kind of mapping.  The cleaned up logs are in that
> > directory as well.
> 
> I took those cleaned up log files (which run from 2.6.11 to 2.6.22) and
> created some new ones (raw, I didn't try to clean them) for 2.6.23, 2.6.24,
> 2.6.25 and 2.6.26-sofar.  Then I skimmed through looking for drive-by
> contributors (defined as someone who contributes to just one release and
> is then never heard from again).
> 
> The summary looks like this:
> 63 in version 2.6.11 never seen again
> 148 in version 2.6.12 never seen again
> 128 in version 2.6.13 never seen again
> 92 in version 2.6.14 never seen again
> 96 in version 2.6.15 never seen again
> 122 in version 2.6.16 never seen again
> 137 in version 2.6.17 never seen again
> 140 in version 2.6.18 never seen again
> 135 in version 2.6.19 never seen again
> 95 in version 2.6.20 never seen again
> 136 in version 2.6.21 never seen again
> 153 in version 2.6.22 never seen again
> 179 in version 2.6.23 never seen again
> 179 in version 2.6.24 never seen again
> 304 in version 2.6.25 never seen again
> 
> These numbers are somewhat exaggerated by typos (the "cleaned up" files
> still have some problems in the "Author:" entry (which is the only one
> I looked at).  People add or drop middle initials, or sometimes switch
> between "Firstname Lastname" and "Lastname, Firstname", and there are
> plenty of obviously garbled entries.
> 
> The numbers for the more recent releases may also include
> people who are still in the community, but just don't contribute to
> every release.
> 
> My script didn't look for people that contributed for two or more
> releases and then disappeared.
> 
> You can skim through the full list at the bottom of this message
> and make your own guesses at how much of this data is garbage.
> Even if 3/4 of the names here can be discounted, that still leaves
> over 500 people who came to us at one point with a patch that was
> good enough to be applied and then they left.

It depends how we see this. Having a lot of external contributors is
very good, as it implies that more and more people are getting used
to read and modify the code. What would be interesting would be to
check for people who where there on a regular basis then went away,
even though I admit is harder to find out.

Willy

