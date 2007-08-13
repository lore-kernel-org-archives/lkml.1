Return-Path: <linux-kernel-owner+w=401wt.eu-S941909AbXHMTXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941909AbXHMTXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943473AbXHMTVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:21:38 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39096 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942229AbXHMTVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:21:34 -0400
Date: Mon, 13 Aug 2007 12:19:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Chris Wright <chrisw@sous-sol.org>, joe@perches.com,
       xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeremy@xensource.com, akpm@linux-foundation.org
Subject: Re: [PATCH] [545/2many] MAINTAINERS - XEN HYPERVISOR INTERFACE
Message-ID: <20070813191938.GI3672@sequoia.sous-sol.org>
References: <46bffcb5.o/KKCq3EZH4S47k3%joe@perches.com> <20070813185536.GH3672@sequoia.sous-sol.org> <20070813121005.af159d1d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813121005.af159d1d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Mon, 13 Aug 2007 11:55:36 -0700 Chris Wright wrote:
> > * joe@perches.com (joe@perches.com) wrote:
> > > +F:	arch/i386/xen/
> > > +F:	drivers/*/xen-*front.c
> > > +F:	drivers/xen/
> > > +F:	include/asm-i386/xen/
> > > +F:	include/xen/
> > 
> > I think this data will easily become stale.  What is the point again?
> 
> Agreed.  But not everyone wants to or should have to use git,
> so what are the alternatives?

Between git (or gitweb), existing MAINTAINERS and a bit of common
sense (or extra sleuthing), I never perceived a significant problem.
Alternative could be to place info directly in source files.  If not
all of MAINTAINERS info, it could be a tag to reference the relevant
MAINTAINERS entry.

thanks,
-chris
