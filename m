Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZICNZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZICNZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbZICNZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:25:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37064 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbZICNXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:23:18 -0400
Message-Id: <20090903132145.482814810@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 03 Sep 2009 15:21:45 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 00/14] load-balancing and cpu_power -v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By popular demand the latest version of my patch queue on the subject ;-)

It has the aperf/mperf bits (although I haven't got an SMT capable machine
to test).

It also includes a few wake_idle cleanups which seem to regress my kbuild
test, so I'll have to prod a bit more at that.

Enjoy!

