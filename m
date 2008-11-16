Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYKPSg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYKPSg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYKPSeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:34:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42920 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbYKPSeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:34:19 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "alexs" <alex.shi@intel.com>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>,
       "Mike Christie" <michaelc@cs.wisc.edu>,
       "Yanmin Zhang" <yanmin_zhang@linux.intel.com>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.27G.vBGIJB@chimera>
Subject: [Bug #11898] mke2fs hang on AIC79 device.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:14 +0100 (CET)
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
Date		: 2008-10-30 01:17 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f0c0a376d0fcd4c5579ecf5e95f88387cba85211
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
		  Mike Christie <michaelc@cs.wisc.edu>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11898#c28
		  http://bugzilla.kernel.org/show_bug.cgi?id=11898#c36


