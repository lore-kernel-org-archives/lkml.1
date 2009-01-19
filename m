Return-Path: <linux-kernel-owner+w=401wt.eu-S1762567AbZATAOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762567AbZATAOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762098AbZATAGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:06:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40618 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbZATAGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:06:01 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <ak@linux.intel.com>, "Len Brown" <len.brown@intel.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Thomas Renninger" <trenn@suse.de>, "Tino Keitel" <tino.keitel@gmx.de>,
       "Zhang Rui" <rui.zhang@intel.com>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
In-Reply-To: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX2gZ6Cy9nC.A.nnC.3JRdJB@chimera>
Subject: [Bug #12401] 2.6.28 regression: xbacklight broken on ThinkPad X61s
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:45:41 +0100 (CET)
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
Date		: 2009-01-05 8:39 (15 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=22c13f9d8179f4c9caecfcb60a95214562b9addc
References	: http://marc.info/?l=linux-kernel&m=123114479110314&w=4


