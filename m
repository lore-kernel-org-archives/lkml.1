Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZGVDEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZGVDEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZGVDEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:04:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52173
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbZGVDEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:04:32 -0400
Date: Tue, 21 Jul 2009 20:04:37 -0700 (PDT)
Message-Id: <20090721.200437.193707224.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       samuel.ortiz@intel.com, yi.zhu@intel.com, linville@tuxdriver.com
Subject: Re: linux-next: manual merge of the net tree with the
 wireless-current tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090722115956.482777b4.sfr@canb.auug.org.au>
References: <20090722115956.482777b4.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 22 Jul 2009 11:59:56 +1000

> Today's linux-next merge of the net tree got a conflict in
> drivers/net/wireless/iwmc3200wifi/netdev.c between commit
> 513a2396d8e8327aff1ce50bea3fb4f16ff3455b ("iwmc3200wifi: fix NULL pointer
> dereference in iwm_if_free") from the wireless-current tree and commit
> 3549716484a95fd16f7fcf8b68699bd4c803b382 ("iwmc3200wifi: cache keys when
> interface is down") from the net tree.
> 
> Just context changes.   I fixed it up (see below) and can carry the fix
> as necessary.

Thanks Stephen, I'll let Linville and the wireless folks sort
this one out.
