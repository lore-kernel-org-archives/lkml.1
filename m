Return-Path: <linux-kernel-owner+w=401wt.eu-S933475AbYD3VwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbYD3VwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbYD3Vvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:51:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39022
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759169AbYD3Vvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:51:52 -0400
Date: Wed, 30 Apr 2008 14:51:50 -0700 (PDT)
Message-Id: <20080430.145150.50176543.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, greg@kroah.com
Subject: [GIT]: IPV6 build fix.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull to get this fix for a build regression.

Thanks!

The following changes since commit 159131149c2f56c1da5ae5e23ab9d5acef4916d1:
  Lachlan Andrew (1):
        tcp: Overflow bug in Vegas

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Pavel Emelyanov (1):
      ipv6: Compilation fix for compat MCAST_MSFILTER sockopts.

 net/ipv6/ipv6_sockglue.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)
