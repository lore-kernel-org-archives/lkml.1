Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601Ab0AXWox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab0AXWox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288Ab0AXWor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:44:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45767 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0AXWfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:35:36 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Soeren Sandmann" <sandmann@daimi.au.dk>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.5sB.QbMXLB@chimera>
Subject: [Bug #14625] Commit d451564 breaks ARM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:22:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14625
Subject		: Commit d451564 breaks ARM
Submitter	: Russell King <rmk+lkml@arm.linux.org.uk>
Date		: 2009-11-13 15:11 (73 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d4515646699b6ad7b1a98ceb871296b957f3ef47
References	: http://marc.info/?l=linux-kernel&m=125812520315835&w=4


