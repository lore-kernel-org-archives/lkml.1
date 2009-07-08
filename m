Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZGHR4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZGHR4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZGHR4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:56:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50944
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbZGHR4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:56:03 -0400
Date: Wed, 08 Jul 2009 10:56:06 -0700 (PDT)
Message-Id: <20090708.105606.227710373.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 0/8 net-next-2.6] cxgb3: driver update
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A54332D.3010102@chelsio.com>
References: <4A54332D.3010102@chelsio.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Tue, 07 Jul 2009 22:48:29 -0700

> I am submitting a series of 8 patches for inclusion in net-next-2.6.
> Here is a brief description of the patch series:
> - Drain the mac Tx fifo when a port goes down
> - Fix the mac high water computation on T3C chips
> - Fix LED settings and first link status report for the AEL2020 phy
> - Minor fixes to the AQ100X phy
> - Toggles Global Tx disable bit on phys when powered down
> - Fix HW initialization for offload connections
> - Fix MAC indexation for the Gen2 adapter
> - use request_firmware() to load the phy EDC programming.

Looks good, all applied.

Thanks for taking care of the request_firmware() issue.
