Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbXH0MZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbXH0MZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXH0MYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:24:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44913 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbXH0MYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:24:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2 regression in 2.6.21)
Date: Mon, 27 Aug 2007 14:35:37 +0200
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Walker" <dwalker@mvista.com>,
       "=?iso-8859-1?q?Bj=F6rn?= Steinbrink" <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       "Natalie Protasevich" <protasnb@gmail.com>
References: <1186531609.22044.50.camel@imap.mvista.com> <20070827005131.b93f5935.akpm@linux-foundation.org> <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
In-Reply-To: <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708271435.38518.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27 August 2007 13:38, Michal Piotrowski wrote:
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

The unresolved ones, that is?  If you can do that, it would be a very good
thing, IMO.

Greetings,
Rafael
