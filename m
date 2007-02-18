Return-Path: <linux-kernel-owner+w=401wt.eu-S2992978AbXBRBeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992978AbXBRBeI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 20:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992977AbXBRBeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 20:34:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:59415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030278AbXBRBeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 20:34:07 -0500
Date: Sat, 17 Feb 2007 17:32:19 -0800
From: Greg KH <greg@kroah.com>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 04/44 take 2] [UBI] kernel-spce API header
Message-ID: <20070218013219.GA2997@kroah.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165444.5845.9892.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217165444.5845.9892.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 06:54:44PM +0200, Artem Bityutskiy wrote:
> diff -auNrp tmp-from/include/linux/mtd/ubi.h tmp-to/include/linux/mtd/ubi.h
> --- tmp-from/include/linux/mtd/ubi.h	1970-01-01 02:00:00.000000000 +0200
> +++ tmp-to/include/linux/mtd/ubi.h	2007-02-17 18:07:26.000000000 +0200
> @@ -0,0 +1,391 @@
> +/*
> + * Copyright (c) International Business Machines Corp., 2006
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.

Are you sure this is the proper license for new kernel code coming from
IBM these days?  You might want to go verify that the "or any later
version" is allowed right now...

thanks,

greg k-h
