Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbXHaKMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbXHaKMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 06:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbXHaKMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 06:12:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56152 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbXHaKMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 06:12:22 -0400
Date: Fri, 31 Aug 2007 19:12:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "mel@csn.ul.ie" <mel@csn.ul.ie>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] CONFIG_ZONE_MOVABLE [0/2] introduction
Message-Id: <20070831191202.50fe90b3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rebased version for making ZONE_MOVABLE configurable.

[1/2] .... clean up. this changes ZONE_xxx definitions and helps avoiding
           too many CONFIG_ZONE_xxx usage.
[2/2] .... make ZONE_MOVABLE configurable.


This patch set is against 2.6.23-rc3-mm1. tested on i386/UP and ia64/NUMA

If I should wait for a while (until vm setteled down), I'll wait.

Regards,
-Kame

