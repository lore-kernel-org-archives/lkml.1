Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYHVWPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYHVWPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYHVWPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:15:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48549 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbYHVWPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:15:42 -0400
Message-ID: <48AF3A87.1070705@pobox.com>
Date: Fri, 22 Aug 2008 18:15:35 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Karen Xie <kxie@chelsio.com>
CC: netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net, michaelc@cs.wisc.edu, swise@opengridcomputing.com,
       rdreier@cisco.com, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com, leedom@chelsio.com
Subject: Re: [PATCH 0/4 2.6.28] cxgb3i - Add iSCSI driver
References: <200808221837.m7MIbAvv004384@localhost.localdomain>
In-Reply-To: <200808221837.m7MIbAvv004384@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karen Xie wrote:
> Hi, everyone,
> 
> Please review our new version of the iSCSI Initiator drivers for Chelsio S3 adapters. The cxgb3i driver provides iscsi acceleration (PDU digest offload and payload direct-placement) to the open-iscsi initiator. It accesses the hardware through the cxgb3 module.
> 
> The accelerated iscsi traffic uses a private IP address which is unknown to the OS.

I have not reviewed in depth, but this does appear to remove the major 
objection we had.

Thanks,

	Jeff



