Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbXAaRDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbXAaRDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933039AbXAaRDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:03:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933174AbXAaRDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:03:32 -0500
Message-ID: <45C0CBF7.9000206@sandeen.net>
Date: Wed, 31 Jan 2007 11:03:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org>
In-Reply-To: <45BFA087.6020905@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Roland Dreier wrote:
>> And I seem to recall there's more SATA chipset documentation than Jeff
>> Garzik has time to implement support for.
> 
> I seriously doubt you can come up with even a single concrete example here.

Not trying to slight Jeff here in any way, but I thought I'd point out
one driver-less SATA chip that seems to have docs available.

When looking for a sata controller I came across several inexpensive
ones based on an Initio chipset, and at first glance it seems that they
have docs out there*: http://www.initio.com/products/sata.htm

but no drivers yet.  Just in case anyone is interested :)

-Eric


*knowing next to nothing about SATA, I have no idea if these docs are
sufficient.
