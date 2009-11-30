Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZK3BL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZK3BL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 20:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZK3BL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 20:11:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46258
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbZK3BL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 20:11:56 -0500
Date: Sun, 29 Nov 2009 17:12:02 -0800 (PST)
Message-Id: <20091129.171202.169130093.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, bruce.w.allan@intel.com,
       jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091124141131.49b37eec.sfr@canb.auug.org.au>
References: <20091124141131.49b37eec.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 24 Nov 2009 14:11:31 +1100

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/e1000e/phy.c between commit
> 189983d469c6d98e64ddfb9f9ce76725cb082ee5 ("e1000e: remove unnecessary
> 82577 workaround causing link issues") from the net-current tree and
> commit 94d8186a693284344ee5cb9734086c7a2370241a ("e1000e: cleanup ops
> function pointers") from the net tree.
> 
> I fixed it up (see below) and can carry the fix for a while.

This conflict also got dealt with last night when I pulled
net-2.6 into net-next-2.6
