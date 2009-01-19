Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZASS74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZASS74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZASS7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:59:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:52629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZASS7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:59:46 -0500
Date: Mon, 19 Jan 2009 10:57:04 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 19 (DST)
Message-ID: <20090119185704.GA6407@suse.de>
References: <20090119172732.e772d8ea.sfr@canb.auug.org.au> <4974C288.7030301@oracle.com> <20090119183046.GA28947@ioremap.net> <4974CAD2.8050500@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4974CAD2.8050500@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 10:47:46AM -0800, Randy Dunlap wrote:
> Evgeniy Polyakov wrote:
> > Hi Randy.
> > 
> > On Mon, Jan 19, 2009 at 10:12:24AM -0800, Randy Dunlap (randy.dunlap@oracle.com) wrote:
> >>> There will be no build results for today's linux-next as our build server
> >>> has failed.
> >>>
> >>> Changes since 20090116:
> >>
> >> DST build fails when CONFIG_BLOCK=n:
> > 
> > DST should depend on block and block device, in the original patch its
> > kconfig entry was in the BLK_DEV menu, so this dependency was satisfied
> > automatically. Should attached patch be pushed into drivers/staging?
> 
> Yes, thanks.
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, I'll queue it up for inclusion in my tree tomorrow.

greg k-h
