Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbXBUUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbXBUUlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXBUUlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:41:20 -0500
Received: from mail.suse.de ([195.135.220.2]:49309 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516AbXBUUlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:41:19 -0500
Date: Wed, 21 Feb 2007 12:39:28 -0800
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/21] 2.6.19-stable review
Message-ID: <20070221203928.GC17830@kroah.com>
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DC9E1D.40805@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 02:31:41PM -0500, Chuck Ebbert wrote:
> Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.19.5 release.
> > 
> > This will probably be the last release of the 2.6.19-stable series, so
> > if there are patches that you feel should be applied to that tree,
> > please let me know.
> > 
> > There are 21 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> > 
> 
> What is the status of:
> 
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-simplfy-__assign_irq_vector.patch
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
> 
> They fix a serious bug that causes machines to freeze up
> or just run very slowly.
> 
> I'd like to see these in -stable if possible.

-stable for 2.6.19 and/or .18?

I haven't pushed out the next round of patches for the 2.6.20-stable
tree, I have a _lot_ of them there to catch up on still...

thanks,

greg k-h
