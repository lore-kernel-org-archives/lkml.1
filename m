Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbZBHWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbZBHWCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZBHVuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:50:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbZBHVuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:50:16 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Paul Collins" <paul@burly.ondioline.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.p4D.L20jJB@chimera>
Subject: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:49 +0100 (CET)
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
Date		: 2009-01-21 7:15 (19 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c5745aa380efb6417b5681104b007c8612fb496
References	: http://marc.info/?l=linux-kernel&m=123252215315106&w=4


