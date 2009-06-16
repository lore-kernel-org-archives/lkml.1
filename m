Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZFPEBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZFPEBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZFPEBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:01:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:58700 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZFPEBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:01:45 -0400
Date: Mon, 15 Jun 2009 20:56:30 -0700
From: Greg KH <gregkh@suse.de>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: Linux 2.6.29.5
Message-ID: <20090616035630.GA30380@suse.de>
References: <20090615200304.GA2003@kroah.com> <200906160648.04627.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906160648.04627.a1426z@gawab.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 06:48:04AM +0300, Al Boldi wrote:
> Greg KH wrote:
> > I'm announcing the release of the 2.6.29.5 kernel.  All users of the
> > 2.6.29 kernel series are very strongly encouraged to upgrade.
> >
> > I'll also be replying to this message with a copy of the patch between
> > 2.6.29.4 and 2.6.29.5
> >
> > The updated 2.6.29.y git tree can be found at:
> >        
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.29.y.git and
> > can be browsed at the normal kernel.org git web browser:
> >        
> > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=summa
> 
> It may be a good idea to also allow pulling patches over email.

I'm confused as to why you would want this.  kernel.org is mirrored all
around the world, so the tree can be found through ftp and http
everywhere.

> Majordomo has such a facility via the "index" and "get" commands.

Majordomo is not used here for email delivery.

thanks,

greg k-h
