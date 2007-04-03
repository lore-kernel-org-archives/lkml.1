Return-Path: <linux-kernel-owner+w=401wt.eu-S1030295AbXDCPAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030295AbXDCPAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030302AbXDCPAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:00:44 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41795 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030295AbXDCPAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:00:43 -0400
Date: Tue, 3 Apr 2007 17:00:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
Message-ID: <20070403150042.GK14134@stusta.de>
References: <4611652F.700@zytor.com> <200704031030.36473.ak@suse.de> <20070403111731.52f2102a@gondolin.boeblingen.de.ibm.com> <200704031126.52750.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200704031126.52750.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 11:26:52AM +0200, Andi Kleen wrote:
> > 
> > On s390, it would be more than strangeness. There's no implementation
> > of PCI at all, someone would have to cook it up - and it wouldn't have
> > any use beyond those special devices. Since there isn't any bus type
> > that is available on *all* architectures, a generic "virtual" bus with
> > very simple probing seems much saner...
> 
> You just have to change all the distribution installers then. 
> Ok I suppose on s390 that's not that big issue because there are not
> that many for s390. But for x86 there exist quite a lot. I suppose
> it's easier to change it in the kernel.

I don't get this point.

Compared to whatever will be done in the kernel, any change to a 
distribution installer should be trivial.

And a new release of a distribution with a new kernel might anyway 
usually require some updates to an installer.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

