Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbZCUTWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbZCUTWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbZCUTS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:18:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51879 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbZCUTSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:18:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>,
       "Linux ACPI" <linux-acpi@vger.kernel.org>, "Orivej Desh" <smpuj@bk.ru>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
In-Reply-To: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l8NZ2a3iQtG.A.DwB.qaTxJB@chimera>
Subject: [Bug #12681] s2ram: fails to wake up on Acer Extensa 4220 (SMP disabled)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 17:39:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12681
Subject		: s2ram: fails to wake up on Acer Extensa 4220 (SMP disabled)
Submitter	: Orivej Desh <smpuj@bk.ru>
Date		: 2009-02-09 13:01 (41 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cfe62c8010ac56e1bd3827e30386a87cc2f3594


