Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbXIPVzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbXIPVzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXIPVyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:54:53 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:51952
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbXIPVyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:54:52 -0400
Date: Sun, 16 Sep 2007 14:54:32 -0700 (PDT)
Message-Id: <20070916.145432.26527041.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: satyam@infradead.org, kaber@trash.net
Subject: Re: + net-sched-sch_cbqc-shut-up-uninitialized-variable.patch
 added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200709130725.l8D7PaPJ007684@imap1.linux-foundation.org>
References: <200709130725.l8D7PaPJ007684@imap1.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Thu, 13 Sep 2007 00:25:36 -0700

> From: Satyam Sharma <satyam@infradead.org>
> 
> net/sched/sch_cbq.c: In function 'cbq_enqueue':
> net/sched/sch_cbq.c:383: warning: 'ret' may be used uninitialized in this function
> 
> has been verified to be a bogus case. So let's shut it up.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> Acked-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Applied to net-2.6, thanks!
