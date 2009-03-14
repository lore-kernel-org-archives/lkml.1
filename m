Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbZCNVqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbZCNVqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759209AbZCNVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:43:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202AbZCNVnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:43:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>,
       "Linux ACPI" <linux-acpi@vger.kernel.org>, "Orivej Desh" <smpuj@bk.ru>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
In-Reply-To: <MiincthRUSI.A.eKC.F4BvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GCLaknAim2M.A.4ZE.V5BvJB@chimera>
Subject: [Bug #12681] s2ram: fails to wake up on Acer Extensa 4220 (SMP disabled)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:05:30 +0100 (CET)
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
Date		: 2009-02-09 13:01 (34 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cfe62c8010ac56e1bd3827e30386a87cc2f3594


