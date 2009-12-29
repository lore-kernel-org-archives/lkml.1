Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZL2POB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZL2POB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZL2PN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:13:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38937 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbZL2PN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:13:56 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Michael Tokarev" <mjt@tls.msk.ru>, "Michal Marek" <mmarek@suse.cz>,
       "Oliver Hartkopp" <oliver@hartkopp.net>,
       "Sam Ravnborg" <sam@ravnborg.org>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.YoH.XnhOLB@chimera>
Subject: [Bug #14907] Commit "kbuild: fix bzImage build for x86" breaks build
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:09:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14907
Subject		: Commit "kbuild: fix bzImage build for x86" breaks build
Submitter	: Oliver Hartkopp <oliver@hartkopp.net>
Date		: 2009-12-19 19:21 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4a2ff67c88211026afcbdbc190c13f705dae1b59
References	: http://marc.info/?l=linux-kernel&m=126125050622195&w=4
		  http://marc.info/?l=linux-kernel&m=126114565103300&w=4


