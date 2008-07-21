Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbYGUBN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbYGUBN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 21:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYGUBNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 21:13:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38469
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754385AbYGUBNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 21:13:18 -0400
Date: Sun, 20 Jul 2008 18:13:18 -0700 (PDT)
Message-Id: <20080720.181318.17443249.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking build fix.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this build fix for a problem Stephen
Rothwell reported with NET_SCHED disabled.

Thanks!

The following changes since commit fb65a7c091529bfffb1262515252c0d0f6241c5c:
  David S. Miller (1):
        iucv: Fix bad merging.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

David S. Miller (1):
      pkt_sched: Fix build with NET_SCHED disabled.

 include/net/sch_generic.h |    2 ++
 net/sched/sch_generic.c   |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)
