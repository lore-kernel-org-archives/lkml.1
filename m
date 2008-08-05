Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbYHERJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbYHERJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759486AbYHERJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:09:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431AbYHERJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:09:01 -0400
Date: Tue, 5 Aug 2008 10:01:43 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080805170143.GA9639@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com> <1217896374.27684.53.camel@localhost.localdomain> <20080805005132.GA3661@kroah.com> <20080805122503.73ea5416@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805122503.73ea5416@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 12:25:03PM +0100, Alan Cox wrote:
> > Again, do it all in userspace (caching, and scanning).  I still really
> > don't see the need to do this in the kernel becides it being "the way
> > people have always done it."
> 
> We don't have notifiers for file segment changes that are scalable that
> far.

I agree, but if we did, would that help out a lot here?  Lots of other
groups of people are needing/asking for something like this and if
someone can finally get it together to post something useful, that might
be a very good thing.

thanks,

greg k-h
