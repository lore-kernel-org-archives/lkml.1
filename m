Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZJDVAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZJDVAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 17:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbZJDVAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 17:00:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:59922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZJDVAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 17:00:17 -0400
Date: Sun, 4 Oct 2009 22:59:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spelling correction in a comment
In-Reply-To: <alpine.LRH.2.00.0910042257350.22311@twin.jikos.cz>
Message-ID: <alpine.LRH.2.00.0910042258020.22311@twin.jikos.cz>
References: <200910032045.02523.mitov@issp.bas.bg> <alpine.LRH.2.00.0910042257350.22311@twin.jikos.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Oct 2009, Jiri Kosina wrote:

> > Correcting spelling in a comment
> > 
> > Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> > 
> > ======================================================
> > --- a/arch/x86/kernel/pci-dma.c	2009-10-03 19:49:51.000000000 +0300
> > +++ b/arch/x86/kernel/pci-dma.c	2009-10-03 19:50:26.000000000 +0300
> > @@ -35,7 +35,7 @@
> >  
> >  /*
> >   * This variable becomes 1 if iommu=pt is passed on the kernel command line.
> > - * If this variable is 1, IOMMU implementations do no DMA ranslation for
> > + * If this variable is 1, IOMMU implementations do no DMA translation for
> >   * devices and allow every device to access to whole physical memory. This is
> >   * useful if a user want to use an IOMMU only for KVM device assignment to
> >   * guests and not for driver dma translation.
> 
> Applied to trivial queue, thanks.

Oh, Ingo already took it, dropped, sorry for the noise.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

