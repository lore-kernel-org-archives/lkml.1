Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbZCCWLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbZCCWLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbZCCWBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:01:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39423 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757983AbZCCWBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:01:13 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Lin Ming" <ming.m.lin@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Wu Fengguang" <fengguang.wu@intel.com>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.9MB.pUarJB@chimera>
Subject: [Bug #12809] iozone regression with 2.6.29-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:59 +0100 (CET)
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
Date		: 2009-02-27 9:13 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>


