Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0BOGWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:22:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46104
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625Ab0BOGWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:22:17 -0500
Date: Sun, 14 Feb 2010 22:22:32 -0800 (PST)
Message-Id: <20100214.222231.180659633.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, jouni.malinen@atheros.com,
       linville@tuxdriver.com
Subject: Re: linux-next: manual merge of the net tree with the
 wireless-current tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100215152023.0696878f.sfr@canb.auug.org.au>
References: <20100215152023.0696878f.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 15 Feb 2010 15:20:23 +1100

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> net/mac80211/rate.c between commit
> 5affcd6ba2036b59a4dee3f0576ae3584e92e4f1 ("mac80211: fix handling of
> null-rate control in rate_control_get_rate") from the wireless-current
> tree and commit 37eb0b164cf9fa9f70c8500926f5cde7c652f48e
> ("cfg80211/mac80211: Use more generic bitrate mask for rate control")
> from the net tree.
> 
> John, I know you mentioned this, so I assume it will go away soon.
> 
> I fixed it up (I think - see below).

Right, I'll even try to take care of this myself later tonight.
