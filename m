Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbZEXW14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbZEXW14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758341AbZEXW07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:26:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34468 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758007AbZEXW0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:26:55 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>,
       "Linux ACPI" <linux-acpi@vger.kernel.org>, "Orivej Desh" <smpuj@bk.ru>,
       "Zhang Rui" <rui.zhang@intel.com>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
In-Reply-To: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <WCcYF-TAbJC.A.Q3E.2ScGKB@chimera>
Subject: [Bug #12681] s2ram: fails to wake up on Acer Extensa 4220 (SMP disabled)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:31:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12681
Subject		: s2ram: fails to wake up on Acer Extensa 4220 (SMP disabled)
Submitter	: Orivej Desh <smpuj@bk.ru>
Date		: 2009-02-09 13:01 (105 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cfe62c8010ac56e1bd3827e30386a87cc2f3594
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>


