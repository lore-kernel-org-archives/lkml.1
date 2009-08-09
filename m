Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbZHIXis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbZHIXis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZHIXir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:38:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43845 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbZHIXip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:38:45 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>,
       "David Woodhouse" <David.Woodhouse@intel.com>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Pavel Machek" <pavel@ucw.cz>,
       "Tobias Diedrich" <ranma@tdiedrich.de>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
In-Reply-To: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <u1L1PAbl8zG.A.o6D.Fk1fKB@chimera>
Subject: [Bug #13833] Kernel Oops when trying to suspend with ubifs mounted on block2mtd mtd device
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Aug 2009 22:44:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13833
Subject		: Kernel Oops when trying to suspend with ubifs mounted on block2mtd mtd device
Submitter	: Tobias Diedrich <ranma@tdiedrich.de>
Date		: 2009-07-15 14:20 (26 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=15bce40cb3133bcc07d548013df97e4653d363c1
References	: http://marc.info/?l=linux-kernel&m=124766049207807&w=4
		  http://marc.info/?l=linux-kernel&m=124704927819769&w=4


