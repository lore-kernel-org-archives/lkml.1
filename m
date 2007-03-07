Return-Path: <linux-kernel-owner+w=401wt.eu-S2992748AbXCGWsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992748AbXCGWsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992746AbXCGWsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:48:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47388
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992734AbXCGWsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:48:24 -0500
Date: Wed, 07 Mar 2007 14:48:23 -0800 (PST)
Message-Id: <20070307.144823.08321622.davem@davemloft.net>
To: bunk@stusta.de
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC: net-2.6.20 patch] remove unused exports
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070307224059.GA3441@stusta.de>
References: <20070307224059.GA3441@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Wed, 7 Mar 2007 23:40:59 +0100

> This patch removes the following not or no longer used exports:
> - drivers/char/random.c: secure_tcp_sequence_number
> - net/dccp/options.c: sysctl_dccp_feat_sequence_window
> - net/netlink/af_netlink.c: netlink_set_err
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied to net-2.6.22, thanks Adrian.
