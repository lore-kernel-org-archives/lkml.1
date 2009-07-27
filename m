Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZG0Q3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZG0Q3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbZG0Q3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:29:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:56479 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbZG0Q3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:29:03 -0400
Date: Mon, 27 Jul 2009 09:26:01 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
Subject: Re: [PATCH] documentation: make it clear that sysfs is optional
Message-ID: <20090727162601.GA3632@suse.de>
References: <20090727090642.0e495919.randy.dunlap@oracle.com>
 <20090727161031.GA15328@suse.de>
 <20090727091824.38d55ea1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727091824.38d55ea1.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 09:18:24AM -0700, Randy Dunlap wrote:
> On Mon, 27 Jul 2009 09:10:33 -0700 Greg KH wrote:
> 
> > On Mon, Jul 27, 2009 at 09:06:42AM -0700, Randy Dunlap wrote:
> > > From:	Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
> > > Subject: [PATCH] documentation: make it clear that sysfs is optional
> > > 
> > > The original text suggested that sysfs is mandatory and always
> > > compiled in the kernel.
> > 
> > But it should be :)
> 
> Well, you have the option of making it non-optional.
> 
> 
> > Seriously, who turns sysfs off these days, does anyone?  If so, why?
> 
> Why is it configurable then?

Probably the same reason /proc is configurable.  No one ever turns it
off, but hey, it's possible :)

thanks,

greg k-h
