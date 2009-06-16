Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbZFPFWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbZFPFWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZFPFVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:21:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbZFPFVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:21:48 -0400
Date: Mon, 15 Jun 2009 22:14:15 -0700
From: Greg KH <gregkh@suse.de>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: Linux 2.6.29.5
Message-ID: <20090616051415.GA30708@suse.de>
References: <20090615200304.GA2003@kroah.com> <200906160648.04627.a1426z@gawab.com> <20090616035630.GA30380@suse.de> <200906160733.57322.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906160733.57322.a1426z@gawab.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 07:33:57AM +0300, Al Boldi wrote:
> > > It may be a good idea to also allow pulling patches over email.
> >
> > I'm confused as to why you would want this.  kernel.org is mirrored all
> > around the world, so the tree can be found through ftp and http
> > everywhere.
> 
> Sometimes the only ports open are 110 and 25.

That would not sound like an environment in which kernel development can
happen very easily.

> > > Majordomo has such a facility via the "index" and "get" commands.
> >
> > Majordomo is not used here for email delivery.
> 
> Strange, vger.kernel.org sends via majordomo.

For subscribing to lists only, not for email delivery.

thanks,

greg k-h
