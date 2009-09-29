Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZI2ArG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZI2ArG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZI2ArF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:47:05 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:35814 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753728AbZI2ArE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:47:04 -0400
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
In-Reply-To: <20090929002056.GA31372@kroah.com>
References: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
	 <20090929002056.GA31372@kroah.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 28 Sep 2009 17:47:08 -0700
Message-Id: <1254185228.13456.34.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 2009-09-28 at 17:20 -0700, Greg KH wrote:
> On Mon, Sep 28, 2009 at 04:56:45PM -0700, Shreyas Bhatewara wrote:
> > Ethernet NIC driver for VMware's vmxnet3
> > 
> > From: Shreyas Bhatewara <sbhatewara@vmware.com>
> > 
> > This patch adds driver support for VMware's virtual Ethernet NIC : vmxnet3
> > Guests running on VMware hypervisors supporting vmxnet3 device will thus
> > have access to improved network functionalities and performance.
> > 
> > Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>
> 
> I thought this was going to be submitted for the drivers/staging/ tree.
> What happened?

We managed to do most of the cleanup's inhouse over the weekend and
think this shouldn't need any major cleanup now. That's why thought
better to submit directly. 

Thanks,
Alok

> 
> thanks,
> 
> greg k-h
> _______________________________________________
> Pv-drivers mailing list
> Pv-drivers@vmware.com
> http://mailman2.vmware.com/mailman/listinfo/pv-drivers

