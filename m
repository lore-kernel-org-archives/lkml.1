Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZBHV57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZBHV57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZBHVt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:49:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39682 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbZBHVtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:49:25 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.KIF.j20jJB@chimera>
Subject: [Bug #12618] hackbench [pthread mode] regression with 2.6.29-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12618
Subject		: hackbench [pthread mode] regression with 2.6.29-rc3
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-02-01 7:30 (8 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=490dea45d00f01847ebebd007685d564aaf2cd98
References	: http://marc.info/?l=linux-kernel&m=123347347726527&w=4
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://marc.info/?l=linux-kernel&m=123383366122146&w=4
		  http://marc.info/?l=linux-kernel&m=123383366222152&w=4


