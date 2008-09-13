Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYIMTcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYIMTcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 15:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYIMTbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 15:31:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50177 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbYIMTbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 15:31:50 -0400
Message-ID: <48CC1520.5070309@pobox.com>
Date: Sat, 13 Sep 2008 15:31:44 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Karen Xie <kxie@chelsio.com>
CC: netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net, michaelc@cs.wisc.edu, swise@opengridcomputing.com,
       rdreier@cisco.com, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com, leedom@chelsio.com
Subject: Re: [PATCH 2/4 2.6.28] cxgb3 - handle ARP replies for private iSCSI
 IP address
References: <200808280421.m7S4Lw4r006465@localhost.localdomain>
In-Reply-To: <200808280421.m7S4Lw4r006465@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karen Xie wrote:
> [PATCH 2/4 2.6.28] cxgb3 - handle ARP replies for private iSCSI IP address
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> The accelerated iSCSI traffic uses a private IP address unknown to the OS.
> The driver has to reply to ARP requests dedicated to the private IP address.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


