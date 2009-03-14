Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbZCNVtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbZCNVtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbZCNVnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:43:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41609 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759283AbZCNVnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:43:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Lin Ming" <ming.m.lin@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Wu Fengguang" <fengguang.wu@intel.com>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
In-Reply-To: <MiincthRUSI.A.eKC.F4BvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GCLaknAim2M.A.BKD.q4BvJB@chimera>
Subject: [Bug #12809] iozone regression with 2.6.29-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:05:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809
Subject		: iozone regression with 2.6.29-rc6
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2009-02-27 9:13 (16 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>


