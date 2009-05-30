Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbZE3W6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbZE3W6C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:58:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbZE3Wye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:54:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46798 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759566AbZE3Wyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:54:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "cedric" <cedric@belbone.be>, "Peter Zijlstra" <peterz@infradead.org>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A.7BG.iVbIKB@chimera>
Subject: [Bug #13269] WARNING: at kernel/hrtimer.c:625 hres_timers_resume+0x3c/0x48() when resuming
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13269
Subject		: WARNING: at kernel/hrtimer.c:625 hres_timers_resume+0x3c/0x48() when resuming
Submitter	: cedric <cedric@belbone.be>
Date		: 2009-05-08 08:48 (23 days old)


