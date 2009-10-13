Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbZJMKph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbZJMKph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759429AbZJMKpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:45:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49877
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759407AbZJMKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:45:36 -0400
Date: Tue, 13 Oct 2009 03:45:32 -0700 (PDT)
Message-Id: <20091013.034532.36362276.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: thomas@wytron.com.tw, netdev@vger.kernel.org,
       thierry.reding@avionic-design.de, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add netdev_alloc_skb_ip_align() helper
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ACD585B.5080106@gmail.com>
References: <1254969161-3609-1-git-send-email-thomas@wytron.com.tw>
	<4ACD585B.5080106@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 08 Oct 2009 05:11:23 +0200

> [PATCH] net: Add netdev_alloc_skb_ip_align() helper
> 
> Instead of hardcoding NET_IP_ALIGN stuff in various network drivers, we can
> add a helper around netdev_alloc_skb()
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied to net-next-2.6
