Return-Path: <linux-kernel-owner+w=401wt.eu-S964813AbXDCJ07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813AbXDCJ07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 05:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965028AbXDCJ07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 05:26:59 -0400
Received: from ns1.suse.de ([195.135.220.2]:37919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989AbXDCJ06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 05:26:58 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: A set of "standard" virtual devices?
Date: Tue, 3 Apr 2007 11:26:52 +0200
User-Agent: KMail/1.9.6
Cc: Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <200704031030.36473.ak@suse.de> <20070403111731.52f2102a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070403111731.52f2102a@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704031126.52750.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On s390, it would be more than strangeness. There's no implementation
> of PCI at all, someone would have to cook it up - and it wouldn't have
> any use beyond those special devices. Since there isn't any bus type
> that is available on *all* architectures, a generic "virtual" bus with
> very simple probing seems much saner...

You just have to change all the distribution installers then. 
Ok I suppose on s390 that's not that big issue because there are not
that many for s390. But for x86 there exist quite a lot. I suppose
it's easier to change it in the kernel.

-Andi
