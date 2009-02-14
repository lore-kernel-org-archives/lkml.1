Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZBNXNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZBNXNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZBNXH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:07:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44581 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbZBNXHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:07:20 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
In-Reply-To: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rjPbZ5GRJPO.A.hyE.1r0lJB@chimera>
Subject: [Bug #12618] hackbench [pthread mode] regression with 2.6.29-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:38:20 +0100 (CET)
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
Date		: 2009-02-01 7:30 (14 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=490dea45d00f01847ebebd007685d564aaf2cd98
References	: http://marc.info/?l=linux-kernel&m=123347347726527&w=4
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://marc.info/?l=linux-kernel&m=123383366122146&w=4
		  http://marc.info/?l=linux-kernel&m=123383366222152&w=4


