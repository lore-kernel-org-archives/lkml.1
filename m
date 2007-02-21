Return-Path: <linux-kernel-owner+w=401wt.eu-S1423148AbXBUVYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423148AbXBUVYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423161AbXBUVX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:23:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:34095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423144AbXBUVVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:21:05 -0500
Date: Wed, 21 Feb 2007 23:20:42 +0100
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/21] 2.6.19-stable review
Message-ID: <20070221222042.GG12472@bingen.suse.de>
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com> <20070221114737.a09be761.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221114737.a09be761.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 11:47:37AM -0800, Andrew Morton wrote:
> On Wed, 21 Feb 2007 14:31:41 -0500
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > Greg KH wrote:
> > > This is the start of the stable review cycle for the 2.6.19.5 release.
> > > 
> > > This will probably be the last release of the 2.6.19-stable series, so
> > > if there are patches that you feel should be applied to that tree,
> > > please let me know.
> > > 
> > > There are 21 patches in this series, all will be posted as a response to
> > > this one.  If anyone has any issues with these being applied, please let
> > > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > > to add a Signed-off-by: line to the patch, please respond with it.
> > > 
> > 
> > What is the status of:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-simplfy-__assign_irq_vector.patch
> > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
> 
> That's mainly an Andi decision.  Let's cc him.

I didn't think the problem was serious enough for a backport. Do we have
user reports? 

It's certainly not trivial obvious patches. 

Eric, what is your opinion? 

-Andi
