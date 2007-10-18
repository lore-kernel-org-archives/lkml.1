Return-Path: <linux-kernel-owner+w=401wt.eu-S1762530AbXJRCsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762530AbXJRCsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760073AbXJRCrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:47:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34983 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759996AbXJRCry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:47:54 -0400
Date: Thu, 18 Oct 2007 04:49:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: torvalds@osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>
Subject: Re: [GIT PULL] 9p patches for 2.6.24 merge window
Message-ID: <20071018024927.GA16138@uranus.ravnborg.org>
References: <a4e6962a0710171434l5ff6cecfib1e8b231b8b610b6@mail.gmail.com> <20071017213906.GB13250@uranus.ravnborg.org> <a4e6962a0710171619r60bea067u5255657381b2d0a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4e6962a0710171619r60bea067u5255657381b2d0a9@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 06:19:53PM -0500, Eric Van Hensbergen wrote:
> On 10/17/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Wed, Oct 17, 2007 at 04:34:02PM -0500, Eric Van Hensbergen wrote:
> > > Linus, please pull from the 'for-linus' branch of:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git/ for-linus
> > >
> > > This tree contains the following:
> > >
> > > Latchesar Ionkov(3):
> > >   attach-per-user support
> > >   rename uid and gid parameters
> > >   define session flags
> > >
> > > Eric Van Hensbergen(4)
> > >   remove sysctl code
> > >   fix bad kconfig cross-dependency
> > >   soften invalidationin loose mode
> > >   make transports dynamic
> >
> > Could you please tag your patches with 9p: or [9p] so it
> > is obvious that they belong to this subsystem.
> > When browsing head-commits and other places this is a great help.
> >
> 
> They should be so tagged, I just stripped it in my pull email summary.

OK - thanks.

	Sam
