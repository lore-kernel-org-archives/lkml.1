Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZJMKrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZJMKrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759300AbZJMKrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:47:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49896
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759280AbZJMKrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:47:12 -0400
Date: Tue, 13 Oct 2009 03:47:08 -0700 (PDT)
Message-Id: <20091013.034708.218523749.davem@davemloft.net>
To: kxie@chelsio.com
Cc: swise@opengridcomputing.com, divy@chelsio.com, rakesh@chelsio.com,
       James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next-2.6] cxgb3: Added private MAC address and
 provisioning packet handler for iSCSI
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910081911.n98JB6na024344@localhost.localdomain>
References: <200910081911.n98JB6na024344@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: kxie@chelsio.com
Date: Thu, 08 Oct 2009 12:11:05 -0700

> From: Karen Xie <kxie@chelsio.com>
> 
> [PATCH v4 net-next-2.6] cxgb3: Added private MAC address and provisioning packet handler for iSCSI
> 
> This patch added support of private MAC address per port and provisioning
> packet handler for iSCSI traffic only.
> 
> The above changes are isolated to the cxgb3 driver, independent of any scsi or iscsi driver changes.
> 
> Acked-by: Karen Xie <kxie@chelsio.com>
> Acked-by: Divy Le Ray <divy@chelsio.com>
> Signed-off-by: Rakesh Ranjan <rakesh@chelsio.com>

Applied to net-next-2.6, thanks.
