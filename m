Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZCCWEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZCCWEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbZCCWAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:00:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125AbZCCV76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:59:58 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, "Orivej Desh" <smpuj@bk.ru>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.Z1C.WVarJB@chimera>
Subject: [Bug #12681] s2ram: fails to wake up on Acer Extensa 4220 (SMP disabled)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:54 +0100 (CET)
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
Date		: 2009-02-09 13:01 (23 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cfe62c8010ac56e1bd3827e30386a87cc2f3594


