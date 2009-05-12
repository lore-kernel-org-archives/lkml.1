Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZELRNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZELRNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZELRNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:13:16 -0400
Received: from kroah.org ([198.145.64.141]:35173 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018AbZELRNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:13:14 -0400
Date: Tue, 12 May 2009 09:08:15 -0700
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Forest Bond <forest@alittletooquiet.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 7
Message-ID: <20090512160815.GB16247@kroah.com>
References: <20090507171918.4ecdd6fd.sfr@canb.auug.org.au> <200905071110.20822.borntraeger@de.ibm.com> <20090507132808.GA14711@storm.local.network> <200905071541.28639.borntraeger@de.ibm.com> <20090507140331.GC21250@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507140331.GC21250@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 07:03:31AM -0700, Greg KH wrote:
> On Thu, May 07, 2009 at 03:41:28PM +0200, Christian Borntraeger wrote:
> > Am Thursday 07 May 2009 15:28:08 schrieb Forest Bond:
> > > Hi,
> > > 
> > > On Thu, May 07, 2009 at 11:10:20AM +0200, Christian Borntraeger wrote:
> > > > can we please remove the wpactl.c.bak file from drivers/staging/vt6655/ ?
> > > 
> > > Yes, of course.  Would you like to just remove it or do you need a patch?
> > 
> > Greg should answer that, he is the owner of the staging tree.
> 
> I'll remove it from your patch that is in the staging tree.  But I'm on
> the road right now, so that's not going to happen until Friday afternoon
> at the earliest...

Now removed.

thanks,

greg k-h
