Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZL2PnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZL2PnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZL2Pda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:33:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbZL2Pd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:33:27 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Soeren Sandmann" <sandmann@daimi.au.dk>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.69D.oxhOLB@chimera>
Subject: [Bug #14625] Commit d451564 breaks ARM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:45 +0100 (CET)
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
Date		: 2009-11-13 15:11 (47 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d4515646699b6ad7b1a98ceb871296b957f3ef47
References	: http://marc.info/?l=linux-kernel&m=125812520315835&w=4


