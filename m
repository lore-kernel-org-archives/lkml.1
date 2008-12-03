Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYLDAHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYLDAHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbYLDACu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:02:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48426 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474AbYLDACs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:02:48 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "alexs" <alex.shi@intel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Yanmin Zhang" <yanmin_zhang@linux.intel.com>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bfPM5B8Tx2B.A.Qi.7pxNJB@chimera>
Subject: [Bug #11970] gettimeofday return a old time in mmbench
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 22:57:59 +0100 (CET)
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
Date		: 2008-11-06 23:57 (28 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=99ebcf8285df28f32fd2d1c19a7166e70f00309c
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Thomas Gleixner <tglx@linutronix.de>
		  Yanmin Zhang <yanmin_zhang@linux.intel.com>


