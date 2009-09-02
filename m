Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbZIBHd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbZIBHd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 03:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZIBHdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 03:33:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41730
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755907AbZIBHdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 03:33:25 -0400
Date: Wed, 02 Sep 2009 00:33:39 -0700 (PDT)
Message-Id: <20090902.003339.204452262.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, roel.kluin@gmail.com
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090902133758.f96cac22.sfr@canb.auug.org.au>
References: <20090902133758.f96cac22.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 2 Sep 2009 13:37:58 +1000

> Today's linux-next merge of the net tree got a conflict in
> drivers/net/yellowfin.c between commit
> e7a5965a81a29a13cd4994fa23a6a7a1488bcdb6 ("yellowfin: Fix buffer underrun
> after dev_alloc_skb() failure") from Linus' tree and commit
> 61357325f377889a1daffa14962d705dc814dd0e ("netdev: convert bulk of
> drivers to netdev_tx_t") from the net tree.
> 
> Just context changes.  I fixed it up (see below) and will carry the fix
> for a while.

I just merged net-2.6 into net-next-2.6 to clear this up for you.
