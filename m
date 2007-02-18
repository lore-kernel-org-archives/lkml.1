Return-Path: <linux-kernel-owner+w=401wt.eu-S1161042AbXBRCCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161042AbXBRCCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 21:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161044AbXBRCCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 21:02:47 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:54966 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161042AbXBRCCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 21:02:46 -0500
Date: Sat, 17 Feb 2007 20:08:01 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 04/44 take 2] [UBI] kernel-spce API header
Message-ID: <20070218020800.GF1038@crusty.rchland.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165444.5845.9892.sendpatchset@localhost.localdomain> <20070218013219.GA2997@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218013219.GA2997@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 05:32:19PM -0800, Greg KH wrote:
> On Sat, Feb 17, 2007 at 06:54:44PM +0200, Artem Bityutskiy wrote:
> > diff -auNrp tmp-from/include/linux/mtd/ubi.h tmp-to/include/linux/mtd/ubi.h
> > --- tmp-from/include/linux/mtd/ubi.h	1970-01-01 02:00:00.000000000 +0200
> > +++ tmp-to/include/linux/mtd/ubi.h	2007-02-17 18:07:26.000000000 +0200
> > @@ -0,0 +1,391 @@
> > +/*
> > + * Copyright (c) International Business Machines Corp., 2006
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> 
> Are you sure this is the proper license for new kernel code coming from
> IBM these days?  You might want to go verify that the "or any later
> version" is allowed right now...

The code was actually released to the community a while ago.  But point noted
and we'll look into it.  Thanks for pointing it out Greg.

josh
