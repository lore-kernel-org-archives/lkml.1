Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbYKIUEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbYKIUEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbYKIT5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:57:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44495 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbYKIT5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:57:15 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Doug Chapman" <doug.chapman@hp.com>,
       "Frank Mayhar" <fmayhar@google.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <peterz@infradead.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.lvF.f4zFJB@chimera>
Subject: [Bug #11965] regression introduced by - timers: fix itimer/many thread hang
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:14 +0100 (CET)
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
Date		: 2008-11-06 11:03 (4 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f06febc96ba8e0af80bcc3eaec0a109e88275fac
References	: http://marc.info/?l=linux-kernel&m=122596943416648&w=4
Handled-By	: Frank Mayhar <fmayhar@google.com>
		  Peter Zijlstra <peterz@infradead.org>
		  Ingo Molnar <mingo@elte.hu>


