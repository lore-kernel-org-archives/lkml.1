Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549Ab0AXWn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0AXWn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829Ab0AXWnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:43:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45805 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab0AXWgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:36:07 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Gary Trakhman" <gary.trakhman@gmail.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Zhao Yakui" <yakui.zhao@intel.com>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.FEB.aaMXLB@chimera>
Subject: [Bug #14782] Suspend hangs Lenovo SL300 after gdm login
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:22:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14782
Subject		: Suspend hangs Lenovo SL300 after gdm login
Submitter	: Gary Trakhman <gary.trakhman@gmail.com>
Date		: 2009-12-10 18:53 (46 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=03ba3782e8dcc5b0e1efe440d33084f066e38cae


