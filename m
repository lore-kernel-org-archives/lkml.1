Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZI2Avj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZI2Avj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbZI2Avi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:51:38 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:49480 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681AbZI2Avh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:51:37 -0400
Subject: Re: [Pv-drivers] [PATCH 2.6.31-rc9] net: VMware virtual Ethernet
	NIC driver: vmxnet3
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Greg KH <greg@kroah.com>
Cc: Shreyas Bhatewara <sbhatewara@vmware.com>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20090929002207.GB31372@kroah.com>
References: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
	 <20090929002207.GB31372@kroah.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 28 Sep 2009 17:51:39 -0700
Message-Id: <1254185499.13456.40.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-09-28 at 17:22 -0700, Greg KH wrote:
> On Mon, Sep 28, 2009 at 04:56:45PM -0700, Shreyas Bhatewara wrote:

> > The patch applies to 2.6.31-rc9.
> 
> 2.6.32-rc1 is out, you should rebase to it as a few tens of thousands of
> changes have already happened since 2.6.31-rc9 :)
> 

Yep, we should rebase this, we will do that while incorporating the
comments that we got from David, and any others that you think we should
be making. 

As a side note, were there any changes in the networking API's, that we
should look out for in the merge cycle ?
If not I think the rebase should be pretty trivial.

Thanks,
Alok

> thanks,
> 
> greg k-h
> _______________________________________________
> Pv-drivers mailing list
> Pv-drivers@vmware.com
> http://mailman2.vmware.com/mailman/listinfo/pv-drivers

