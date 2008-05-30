Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYE3Utt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYE3Utt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYE3Utl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:49:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53736 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYE3Utl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:49:41 -0400
Date: Fri, 30 May 2008 13:47:00 -0700
From: Greg KH <greg@kroah.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Dave Jones <davej@redhat.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How many contributors are we losing
Message-ID: <20080530204700.GA3807@kroah.com>
References: <20080528225136.GA29014@kroah.com> <1FE6DD409037234FAB833C420AA843EC016FFF69@orsmsx424.amr.corp.intel.com> <20080529003657.GA17505@kroah.com> <20080529010055.GA31952@redhat.com> <20080529022632.GB5180@kroah.com> <1FE6DD409037234FAB833C420AA843EC017405EB@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC017405EB@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
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

Well, you do know that the distribution of all of our users are:
	50% only contributed 1 patch
	25% contributed 2
	12% contributed 3
	6% contributed 4
and so on?

Our curve is leveling out much better now though.  For the whole 2.5
release, the top 30 people did over 80% of the work.  Now, the top 30
people are doing 30% of the work.

So it is getting much better, as long as we still continue to keep our
massive rate of change[1] that we have going, and huge number of
developers[2], we should be fine.

So this list doesn't necessarily mean anything is wrong, only that 50%
are one-time contributors.  And I think that shows we are easy to get a
change into our tree from just about anyone, not that we are driving
people away.

thanks,

greg k-h

[1] 7,000 lines added, 2,500 lines removed, 2,400 lines modified, per
day for all of the 2.6.25 release cycle.  That's insane.
[2] 2,598 unique developers from 2.6.20 to 2.6.25
