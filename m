Return-Path: <linux-kernel-owner+w=401wt.eu-S933610AbZJMHQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbZJMHQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933263AbZJMHQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:16:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44892
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758952AbZJMHQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:16:07 -0400
Date: Tue, 13 Oct 2009 00:16:03 -0700 (PDT)
Message-Id: <20091013.001603.160899793.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@linux-foundation.org, chrisw@sous-sol.org, greg@kroah.com,
       virtualization@lists.linux-foundation.org, pv-drivers@vmware.com
Subject: Re: [PATCH 2.6.32-rc4] net: VMware virtual Ethernet NIC driver:
 vmxnet3
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.0910121447090.13205@sbhatewara-dev1.eng.vmware.com>
References: <alpine.LRH.2.00.0910121447090.13205@sbhatewara-dev1.eng.vmware.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Mon, 12 Oct 2009 15:18:42 -0700 (PDT)

> 
> Ethernet NIC driver for VMware's vmxnet3
> 
> From: Shreyas Bhatewara <sbhatewara@vmware.com>
> 
> This patch adds driver support for VMware's virtual Ethernet NIC: vmxnet3
> Guests running on VMware hypervisors supporting vmxnet3 device will thus have
> access to improved network functionalities and performance.
> 
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>
> Signed-off-by: Bhavesh Davda <bhavesh@vmware.com>
> Signed-off-by: Ronghua Zhang <ronghua@vmware.com>

Ok, looks good, applied to net-2.6, thanks!
