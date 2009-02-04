Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbZBDMty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbZBDMty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZBDMs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:48:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZBDMsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:48:25 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Fisher" <bug-track@fisher-privat.net>,
       "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "" <venkatesh.pallipadi@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.dX.QwYiJB@chimera>
Subject: [Bug #12417] glx performance drop with: "x86: PAT: implement track/untrack of pfnmap regions for x86 - v3"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:23:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12417
Subject		: glx performance drop with: "x86: PAT: implement track/untrack of pfnmap regions for x86 - v3"
Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
Date		: 2009-01-06 18:46 (30 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5899329b19100c0b82dc78e9b21ed8b920c9ffb3
References	: http://marc.info/?l=linux-kernel&m=123126782822696&w=4
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
		  Ingo Molnar <mingo@elte.hu>


