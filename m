Return-Path: <linux-kernel-owner+w=401wt.eu-S965369AbXCAQsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbXCAQsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965370AbXCAQsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:48:01 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:61143 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965369AbXCAQsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:48:00 -0500
Date: Thu, 1 Mar 2007 08:43:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrea Arcangeli <andrea@suse.de>, philb@gnu.org, tim@cyberelk.net
Subject: Re: [patch 2.6.21-rc2] parport is an orphan
Message-Id: <20070301084336.de54e153.randy.dunlap@oracle.com>
In-Reply-To: <20070301090249.87ebff38.khali@linux-fr.org>
References: <200702281514.21402.david-b@pacbell.net>
	<20070301090249.87ebff38.khali@linux-fr.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 09:02:49 +0100 Jean Delvare wrote:

> On Wed, 28 Feb 2007 15:14:20 -0800, David Brownell wrote:
> > The writing on the wall seem to be that the parport stack is orphaned,
> > rather than maintained by four folk ... and having a webpage that says
> > the latest patches are based on a 2.5 kernel.
> 
> I share David's impression here. Andrew, can you please pick this patch?

Ditto.

> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>
> 
> > 
> > Index: g26/MAINTAINERS
> > ===================================================================
> > --- g26.orig/MAINTAINERS	2007-02-28 12:46:00.000000000 -0800
> > +++ g26/MAINTAINERS	2007-02-28 12:47:58.000000000 -0800
> > @@ -2552,16 +2552,8 @@ L:	i2c@lm-sensors.org
> >  S:	Maintained
> >  
> >  PARALLEL PORT SUPPORT
> > -P:	Phil Blundell
> > -M:	philb@gnu.org
> > -P:	Tim Waugh
> > -M:	tim@cyberelk.net
> > -P:	David Campbell
> > -P:	Andrea Arcangeli
> > -M:	andrea@suse.de
> >  L:	linux-parport@lists.infradead.org
> > -W:	http://people.redhat.com/twaugh/parport/
> > -S:	Maintained
> > +S:	Orphan
> >  
> >  PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
> >  P:	Tim Waugh


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
