Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZBNXWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZBNXWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbZBNXSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:18:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44816 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437AbZBNXSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:18:48 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <ak@linux.intel.com>, "Len Brown" <len.brown@intel.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Thomas Renninger" <trenn@suse.de>, "Tino Keitel" <tino.keitel@gmx.de>,
       "Zhang Rui" <rui.zhang@intel.com>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
In-Reply-To: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ROx6X68CGJG.A.FEB.M50lJB@chimera>
Subject: [Bug #12401] 2.6.28 regression: xbacklight broken on ThinkPad X61s
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:50:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12401
Subject		: 2.6.28 regression: xbacklight broken on ThinkPad X61s
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2009-01-05 8:39 (41 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=22c13f9d8179f4c9caecfcb60a95214562b9addc
References	: http://marc.info/?l=linux-kernel&m=123114479110314&w=4


