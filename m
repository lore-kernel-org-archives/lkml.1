Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbXK1SP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbXK1SP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXK1SPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:15:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:46586 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753919AbXK1SPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:15:10 -0500
X-Authenticated: #1490710
X-Provags-ID: V01U2FsdGVkX19Qpz9ARkpQo3EcPXigJNuAOXLE6TqWotqqC0+E3x
	wuYhv9CQHvJXyX
Date: Wed, 28 Nov 2007 18:14:59 +0000 (GMT)
From: Johannes Schindelin <Johannes.Schindelin@gmx.de>
X-X-Sender: gene099@racer.site
To: Al Boldi <a1426z@gawab.com>
cc: Rogan Dawes <lists@dawes.za.net>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: git guidance
In-Reply-To: <200711282014.27299.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0711281811500.27959@racer.site>
References: <20071127235237.GF15227@1wt.eu> <474D70DD.4020601@dawes.za.net>
 <Pine.LNX.4.64.0711281545170.27959@racer.site> <200711282014.27299.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 28 Nov 2007, Al Boldi wrote:

> git@vger sometimes bounces, so let's leave lkml as backup.

Fair enough.

> Johannes Schindelin wrote:
> > On Wed, 28 Nov 2007, Rogan Dawes wrote:
> > > Al Boldi wrote:
> > > > Willy Tarreau wrote:
> > > > > It should not turn into an endless thread led by people who want 
> > > > > to redefine GIT's roadmap, but experience sharing helps a lot 
> > > > > with GIT.
> > > >
> > > > Well, now that you mentioned it, if there is one thing I dislike, 
> > > > it's for version control to start mutilating your sources.  
> > > > Version Control should be completely transparent.  GIT isn't.
> > >
> > > Care to explain? Git is quite happy handling arbitrary binary 
> > > content, so I find it difficult to believe that it is changing your 
> > > source code in strange ways.
> >
> > It is nice of you to ask him to explain: Unless this handwaving claim 
> > is substantiated, it is quite hard to argue with.
> 
> Sure, the problem with GIT is that it stores the sources inside a 
> backend container that is only accessible via GIT; iow, you can't 
> retrieve your sources directly / transparently.

That is a very funny way to define a "transparent SCM".  Are you 
complaining about SQL servers being "not transparent"?

By that definition, no SCM, not even CVS, is transparent.  Nothing short 
of unpacked directories of all versions (wasting a lot of disk space) 
would.

IOW the issue you raised is a non-issue.

Ciao,
Dscho

