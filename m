Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZHCUVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZHCUVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZHCUVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:21:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43891
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbZHCUVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:21:21 -0400
Date: Mon, 03 Aug 2009 13:21:30 -0700 (PDT)
Message-Id: <20090803.132130.43462719.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch net-next]atl11:set MAX_TX_OFFLOAD_THRESH to 6k from 9k
 and fix spelling error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1249278232896-git-send-email-jie.yang@atheros.com>
References: <1249278232896-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Mon, 3 Aug 2009 13:43:52 +0800

> 1. Set MAX_TX_OFFLOAD_THRESH to 6k from 9k, when mtu large then MAX_TX_OFFLOAD_THRESH
>    just disable NETIF_F_TSO6, NETIF_F_TSO, NETIF_F_HW_CSUM.
> 
> 2. Fix spelling error, change REG_TWSI_CTRL to REG_TXQ_CTRL.
> 
> Signed-off-by: jie yang <jie.yang>@atheros.com

Please repost these two patches with your signoff fixed.

Thanks.
