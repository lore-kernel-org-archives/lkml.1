Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXH0PU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXH0PU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXH0PUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:20:50 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:13247 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbXH0PUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:20:48 -0400
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
	nmi_watchdog=2 regression in 2.6.21)
From: Daniel Walker <dwalker@mvista.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
	 <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 08:13:05 -0700
Message-Id: <1188227585.2435.192.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 13:38 +0200, Michal Piotrowski wrote:
> On 27/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 27 Aug 2007 02:45:02 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> >
> > > Daniel Walker pisze:
> > > [snip]
> > > > Have you considered maintaining all the lists in Bugzilla?
> > >
> > > Yes, I have considered it.
> > >
> > > Bugzilla sucks when it comes to tracking things. There is
> > > a regression field, but there are no difference between
> > > 2.6.22 and 2.6.23 regression.
> > >
> > > Most people are reporting bugs through LKML:
> > > - 23 regressions with reference to LKML
> > > - 4 regressions with reference to Bugzilla
> >
> > Presumably that's fixable.
> >
> > But I think bugzilla is more appropriate for tracking longer-term bugs.  If
> > some problem has just popped up (or has just been discovered) then it's
> > best to try to knock it over with a quick email discussion.  If that
> > doesn't work out then the bug should be captured in bugzilla so that it
> > doesn't get lost.
> >
> > The really important data which bugzilla will record are
> >
> > a) the fact that the bug exists and
> >
> > b) the identity of the person who can reproduce it and who will hopefully
> > work with us on fixing it.
> >
> > > > If you had a
> > > > search of open bugs they would just fall of the list as they get
> > > > closed..
> > >
> > > Unfortunately, the world is not perfect.
> > >
> > > Is anyone interested in maintaining KR list for stable releases?
> >
> > I'm not sure that we need one, really.  Any bugs in a stable release can be
> > handled via email and/or bugzilla as we are presently doing?
> >
> > What I'm concerned about is that regressions which we didn't fix are just
> > getting lost.  Is anyone taking care to ensure that they are getting
> > transitioned into bugzilla for tracking?
> 
> I can copy all regression reports into Bugzilla after each release.

Should we get the regression field fix before? Or had you planned on
just bypassing that completely ?

Daniel

