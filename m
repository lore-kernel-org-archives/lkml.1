Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbXDRTyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbXDRTyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993098AbXDRTyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:54:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51400 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbXDRTyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:54:36 -0400
Date: Wed, 18 Apr 2007 12:29:08 -0700
From: Greg KH <greg@kroah.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux@arm.linux.org.uk, linux-pci@atrey.karlin.mff.cuni.cz,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2.6.21-rc5 1/3] msi: introduce ARCH_SUPPORTS_MSI
	Kconfig option (rev2)
Message-ID: <20070418192908.GA10286@kroah.com>
References: <20070330220243.14060.14389.stgit@dwillia2-linux.ch.intel.com> <20070330230549.14060.70172.stgit@dwillia2-linux.ch.intel.com> <1176885980.4987.67.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176885980.4987.67.camel@concordia.ozlabs.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 06:46:20PM +1000, Michael Ellerman wrote:
> On Fri, 2007-03-30 at 16:05 -0700, Dan Williams wrote:
> > Allows architectures to advertise that they support MSI rather than listing
> > each architecture as a PCI_MSI dependency.
> > 
> > rev2:
> > * update i386 and x86_64 as well
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Hi Greg,
> 
> Are you planning on merging this one? AFAICT it still applies cleanly.
> At the moment my powerpc MSI patches depend on it.

Hm, somehow I missed this, I've now applied it.

thanks,

greg k-h
