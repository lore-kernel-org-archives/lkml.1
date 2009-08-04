Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZHDCi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZHDCi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 22:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZHDCi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 22:38:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49594
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbZHDCi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 22:38:27 -0400
Date: Mon, 03 Aug 2009 19:38:36 -0700 (PDT)
Message-Id: <20090803.193836.248921133.davem@davemloft.net>
To: ghaskins@novell.com
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, shemminger@vyatta.com
Subject: Re: [PATCH v2] net: Add vbus_enet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090804010915.17855.2660.stgit@dev.haskins.net>
References: <20090803171801.17268.93846.stgit@dev.haskins.net>
	<20090804010915.17855.2660.stgit@dev.haskins.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>
Date: Mon, 03 Aug 2009 21:14:04 -0400

> net: Add vbus_enet driver
> 
> A virtualized 802.x network device based on the VBUS interface. It can be
> used with any hypervisor/kernel that supports the virtual-ethernet/vbus
> protocol.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

I'm fine with this, it depends upon the vbus infrastructure so
whoever pulls that in can pull this in as well:

Acked-by: David S. Miller <davem@davemloft.net>
