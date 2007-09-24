Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXIXQXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXIXQXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXIXQW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:22:59 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56277 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbXIXQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:22:58 -0400
Date: Mon, 24 Sep 2007 22:03:26 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.osdl.org,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, efault@gmx.de
Subject: [PATCH 0/5] Fair group scheduler - various fixes
Message-ID: <20070924163326.GA10291@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo and Andrew,
	Here are various patches to fair group scheduler code present in
sched-devel and in 2.6.23-rc7-mm1. These patches should apply against
both sched-devel git tree and 2.6.23-rc7-mm1 (as they are both in sync
now).

Pls consider for inclusion after review.

[there is still room for improving group fairness obtained on smp
systems. By sending out these patches, i am hoping more folks can test
and improve that aspect]

Ingo,
	You may want to avoid picking Patch 5/5 as it makes sense only in
-mm tree atm.

-- 
Regards,
vatsa
