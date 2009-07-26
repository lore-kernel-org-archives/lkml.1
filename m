Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZGZXTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZGZXTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZGZXTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:19:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58515 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbZGZXTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:19:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>,
       "David Woodhouse" <David.Woodhouse@intel.com>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Pavel Machek" <pavel@ucw.cz>,
       "Tobias Diedrich" <ranma@tdiedrich.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
In-Reply-To: <Jya1GruKQpD.A.16.2GObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3zAHs5O6maO.A.gfC.QHObKB@chimera>
Subject: [Bug #13833] Kernel Oops when trying to suspend with ubifs mounted on block2mtd mtd device
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:28:28 +0200 (CEST)
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
Date		: 2009-07-15 14:20 (12 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=15bce40cb3133bcc07d548013df97e4653d363c1
References	: http://marc.info/?l=linux-kernel&m=124766049207807&w=4
		  http://marc.info/?l=linux-kernel&m=124704927819769&w=4


