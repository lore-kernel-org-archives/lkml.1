Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0BABAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 20:00:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50703 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab0BAA74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:59:56 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Len Brown" <len.brown@intel.com>,
       "=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?=" <zajec5@gmail.com>,
       "Stefan Bader" <stefan.bader@canonical.com>,
       "Zhang Rui" <rui.zhang@intel.com>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
In-Reply-To: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <de962C6zBxL.A.qbE.NFiZLB@chimera>
Subject: [Bug #15096] Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  1 Feb 2010 01:43:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15096
Subject		: Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
Submitter	: Rafał Miłecki <zajec5@gmail.com>
Date		: 2010-01-20 23:15 (12 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3a1151e3f124fd1a2c54b8153f510f1a7c715369


