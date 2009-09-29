Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZI2AWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZI2AWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZI2AWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:22:42 -0400
Received: from kroah.org ([198.145.64.141]:42010 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbZI2AWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:22:39 -0400
Date: Mon, 28 Sep 2009 17:20:56 -0700
From: Greg KH <greg@kroah.com>
To: Shreyas Bhatewara <sbhatewara@vmware.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
Subject: Re: [PATCH 2.6.31-rc9] net: VMware virtual Ethernet NIC driver:
 vmxnet3
Message-ID: <20090929002056.GA31372@kroah.com>
References: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 04:56:45PM -0700, Shreyas Bhatewara wrote:
> Ethernet NIC driver for VMware's vmxnet3
> 
> From: Shreyas Bhatewara <sbhatewara@vmware.com>
> 
> This patch adds driver support for VMware's virtual Ethernet NIC : vmxnet3
> Guests running on VMware hypervisors supporting vmxnet3 device will thus
> have access to improved network functionalities and performance.
> 
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

I thought this was going to be submitted for the drivers/staging/ tree.
What happened?

thanks,

greg k-h
