Return-Path: <linux-kernel-owner+w=401wt.eu-S935015AbXHMUWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935015AbXHMUWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933046AbXHMUWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:22:15 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39991 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759996AbXHMUWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:22:13 -0400
Date: Mon, 13 Aug 2007 22:21:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, joe@perches.com,
       xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeremy@xensource.com, akpm@linux-foundation.org
Subject: Re: [PATCH] [545/2many] MAINTAINERS - XEN HYPERVISOR INTERFACE
Message-ID: <20070813202158.GH18945@stusta.de>
References: <46bffcb5.o/KKCq3EZH4S47k3%joe@perches.com> <20070813185536.GH3672@sequoia.sous-sol.org> <20070813121005.af159d1d.randy.dunlap@oracle.com> <20070813191938.GI3672@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070813191938.GI3672@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 12:19:38PM -0700, Chris Wright wrote:
> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
> > On Mon, 13 Aug 2007 11:55:36 -0700 Chris Wright wrote:
> > > * joe@perches.com (joe@perches.com) wrote:
> > > > +F:	arch/i386/xen/
> > > > +F:	drivers/*/xen-*front.c
> > > > +F:	drivers/xen/
> > > > +F:	include/asm-i386/xen/
> > > > +F:	include/xen/
> > > 
> > > I think this data will easily become stale.  What is the point again?
> > 
> > Agreed.  But not everyone wants to or should have to use git,
> > so what are the alternatives?
> 
> Between git (or gitweb), existing MAINTAINERS and a bit of common
> sense (or extra sleuthing), I never perceived a significant problem.

For active kernel developers like you and me it's not a problem.

But for other people it's non-trivial to always figure out who the 
maintainer of some part of the kernel is.

> Alternative could be to place info directly in source files.  If not
> all of MAINTAINERS info, it could be a tag to reference the relevant
> MAINTAINERS entry.

Having the information in MAINTAINERS is what creates the least 
redundancies.

> thanks,
> -chris

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

