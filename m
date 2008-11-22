Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYKVWai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYKVWai (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYKVW2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:28:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37687 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbYKVW2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:28:47 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "alexs" <alex.shi@intel.com>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>,
       "Mike Christie" <michaelc@cs.wisc.edu>,
       "Yanmin Zhang" <yanmin_zhang@linux.intel.com>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.TyD.y8HKJB@chimera>
Subject: [Bug #11898] mke2fs hang on AIC79 device.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11898
Subject		: mke2fs hang on AIC79 device.
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-10-30 01:17 (24 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f0c0a376d0fcd4c5579ecf5e95f88387cba85211
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
		  Mike Christie <michaelc@cs.wisc.edu>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11898#c28
		  http://bugzilla.kernel.org/show_bug.cgi?id=11898#c36


