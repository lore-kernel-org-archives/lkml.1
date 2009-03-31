Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbZCaV0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbZCaV0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZCaV0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:26:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbZCaV0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:26:24 -0400
Date: Tue, 31 Mar 2009 14:22:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: jwboyer@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org, roel.kluin@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add hvc_console to MAINTAINERS
Message-Id: <20090331142252.3bf74fe1.akpm@linux-foundation.org>
In-Reply-To: <1238533823.9715.292.camel@localhost>
References: <49BF956B.9030109@gmail.com>
	<20090330133531.f5d99c09.akpm@linux-foundation.org>
	<20090330205553.GA19278@yoda.jdub.homelinux.org>
	<20090330141852.59baaeda.akpm@linux-foundation.org>
	<20090331132944.GB2332@yoda.jdub.homelinux.org>
	<1238533823.9715.292.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 14:10:23 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2009-03-31 at 09:29 -0400, Josh Boyer wrote:
> > Add a MAINTAINERS entry for the hypervisor virtual console support
> > used on IBM POWER servers.
> > 
> > Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> > ---
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index c5f4e9d..387ad45 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -2176,6 +2176,11 @@ W:       http://www.ia64-linux.org/
> >  T:     git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
> >  S:     Maintained
> >  
> > +IBM HYPERVISOR VIRTUAL CONSOLE
> > +P:     Several
> > +L:     linuxppc-dev@ozlabs.org
> > +S:     Maintained
> > +
> >  IBM MCA SCSI SUBSYSTEM DRIVER
> >  P:     Michael Lang
> >  M:     langa2@kph.uni-mainz.de
> 
> I think this sort of entry should not be acceptable.
> Maintainers should have individual names and contact addresses.

There isn't a maintainer.

But people send patches to the wrong list, so the ppc guys (who use
this driver) don't get to see them.

That's a practical, real-world problem.  We should have a fix for it.

> An exploder entry should be OK though.
> For instance, the DVB subsystem:
> 
> 	DVB SUBSYSTEM AND DRIVERS
> 	P:	LinuxTV.org Project
> 	M:	linux-media@vger.kernel.org
> 
> A list entry could be something like:
> 
> 	P:	Linux PCMCIA Team
> 	L:	linux-pcmcia@lists.infradead.org
> 

I'm unclear on what the difference is here..
