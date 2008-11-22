Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYKVWcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYKVWcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbYKVW33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:29:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37716 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506AbYKVW31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:29:27 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Doug Chapman" <doug.chapman@hp.com>,
       "Frank Mayhar" <fmayhar@google.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "Peter Zijlstra" <peterz@infradead.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.t7C.D8HKJB@chimera>
Subject: [Bug #11965] regression introduced by - timers: fix itimer/many thread hang
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11965
Subject		: regression introduced by - timers: fix itimer/many thread hang
Submitter	: Doug Chapman <doug.chapman@hp.com>
Date		: 2008-11-06 11:03 (17 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f06febc96ba8e0af80bcc3eaec0a109e88275fac
References	: http://marc.info/?l=linux-kernel&m=122596943416648&w=4
Handled-By	: Frank Mayhar <fmayhar@google.com>
		  Peter Zijlstra <peterz@infradead.org>
		  Ingo Molnar <mingo@elte.hu>


