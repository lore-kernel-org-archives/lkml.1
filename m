Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbYHGDoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbYHGDoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 23:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYHGDoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 23:44:13 -0400
Received: from ns2.suse.de ([195.135.220.15]:53518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbYHGDoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 23:44:13 -0400
Date: Wed, 6 Aug 2008 20:40:49 -0700
From: Greg KH <gregkh@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, bwalle@suse.de,
       greg@kroah.com, hugh@veritas.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, haveblue@us.ibm.com
Subject: Re: linux-next: Tree for July 29
Message-ID: <20080807034049.GC3495@suse.de>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au> <20080730090650.79a5a749@kopernikus.site> <20080730021947.def99edc.akpm@linux-foundation.org> <200807302127.42148.bzolnier@gmail.com> <20080730130419.49986a25.akpm@linux-foundation.org> <20080731094105.f6bec082.sfr@canb.auug.org.au> <20080730234419.GA12070@suse.de> <20080807110844.a912483a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807110844.a912483a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 11:08:44AM +1000, Stephen Rothwell wrote:
> HI Greg,
> 
> On Wed, 30 Jul 2008 16:44:19 -0700 Greg KH <gregkh@suse.de> wrote:
> >
> > On Thu, Jul 31, 2008 at 09:41:05AM +1000, Stephen Rothwell wrote:
> > > Hi Andrew,
> > > 
> > > On Wed, 30 Jul 2008 13:04:19 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > > >
> > > > The offending patch has just got itself turfed from linux-next so my
> > > > fix now has nothing to fix.
> > > > 
> > > > We'll see what happens!
> > > 
> > > I will put Dave's patch back with yours on top of it (hoping that Greg
> > > will take your patch).
> > 
> > Greg will, it's in my queue.
> 
> This is still not in your patch series ...  summary email with patch
> repeated below.

Just went in about 3 hours ago :)

I merged it with the original, that's the best way to do it.

thanks,

greg k-h
