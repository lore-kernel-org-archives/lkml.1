Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbYKVWdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbYKVWdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbYKVW3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:29:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37716 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548AbYKVW33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:29:29 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "alexs" <alex.shi@intel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Yanmin Zhang" <yanmin_zhang@linux.intel.com>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.swC._7HKJB@chimera>
Subject: [Bug #11970] gettimeofday return a old time in mmbench
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11970
Subject		: gettimeofday return a old time in mmbench
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-11-06 23:57 (17 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=99ebcf8285df28f32fd2d1c19a7166e70f00309c
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Thomas Gleixner <tglx@linutronix.de>
		  Yanmin Zhang <yanmin_zhang@linux.intel.com>


