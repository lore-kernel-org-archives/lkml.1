Return-Path: <linux-kernel-owner+w=401wt.eu-S974739AbXHMTGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S974739AbXHMTGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947634AbXHMTGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:06:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15094 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940783AbXHMTGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:06:04 -0400
Date: Mon, 13 Aug 2007 12:10:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: joe@perches.com, xen-devel@lists.xensource.com,
       virtualization@lists.osdl.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeremy@xensource.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [545/2many] MAINTAINERS - XEN HYPERVISOR INTERFACE
Message-Id: <20070813121005.af159d1d.randy.dunlap@oracle.com>
In-Reply-To: <20070813185536.GH3672@sequoia.sous-sol.org>
References: <46bffcb5.o/KKCq3EZH4S47k3%joe@perches.com>
	<20070813185536.GH3672@sequoia.sous-sol.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 11:55:36 -0700 Chris Wright wrote:

> * joe@perches.com (joe@perches.com) wrote:
> > Add file pattern to MAINTAINER entry
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index e4e1cc3..8395aba 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5153,6 +5153,11 @@ M:	chrisw@sous-sol.org
> >  L:	virtualization@lists.osdl.org
> >  L:	xen-devel@lists.xensource.com
> >  S:	Supported
> > +F:	arch/i386/xen/
> > +F:	drivers/*/xen-*front.c
> > +F:	drivers/xen/
> > +F:	include/asm-i386/xen/
> > +F:	include/xen/
> 
> I think this data will easily become stale.  What is the point again?

Agreed.  But not everyone wants to or should have to use git,
so what are the alternatives?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
