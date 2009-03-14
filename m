Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbZCNVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbZCNVrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759081AbZCNVnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:43:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41571 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759208AbZCNVnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:43:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Paul Collins" <paul@burly.ondioline.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
In-Reply-To: <MiincthRUSI.A.eKC.F4BvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GCLaknAim2M.A.C9E.g5BvJB@chimera>
Subject: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:05:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12667
Subject		: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
Submitter	: Paul Collins <paul@burly.ondioline.org>
Date		: 2009-01-21 7:15 (53 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c5745aa380efb6417b5681104b007c8612fb496
References	: http://marc.info/?l=linux-kernel&m=123252215315106&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Patch		: http://lkml.org/lkml/2009/2/16/78


