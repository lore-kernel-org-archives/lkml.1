Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbZDFVy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbZDFVy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbZDFVuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:50:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759850AbZDFVun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:50:43 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Lin Ming" <ming.m.lin@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Wu Fengguang" <fengguang.wu@intel.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AsKNxFx2juN.A.41._Gn2JB@chimera>
Subject: [Bug #12809] iozone regression with 2.6.29-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  6 Apr 2009 21:05:38 +0200 (CEST)
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
Date		: 2009-02-27 9:13 (39 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
		  http://lkml.org/lkml/2009/3/14/265
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>


