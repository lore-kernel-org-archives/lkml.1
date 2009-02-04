Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbZBDM4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbZBDM4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZBDMuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:50:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562AbZBDMt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:49:57 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Justin Madru" <jdm64@gawab.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.nXG.evYiJB@chimera>
Subject: [Bug #12505] 2.6.29-rc1 Firefox crashing on page load
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12505
Subject		: 2.6.29-rc1 Firefox crashing on page load
Submitter	: Justin Madru <jdm64@gawab.com>
Date		: 2009-01-16 20:56 (20 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4217458dafaa57d8e26a46f5d05ab8c53cf64191
References	: http://marc.info/?l=linux-kernel&m=123213941914274&w=4
Handled-By	: Justin P. Mattock <justinmattock@gmail.com>


