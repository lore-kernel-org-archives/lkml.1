Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbZEPXGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbZEPXGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbZEPXBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:01:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44273 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462AbZEPXBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:01:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "cedric" <cedric@belbone.be>, "Peter Zijlstra" <peterz@infradead.org>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
In-Reply-To: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pQ9WADCjgyE.A.TFG.BA0DKB@chimera>
Subject: [Bug #13269] WARNING: at kernel/hrtimer.c:625 hres_timers_resume+0x3c/0x48() when resuming
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 22:06:04 +0200 (CEST)
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
Date		: 2009-05-08 08:48 (9 days old)


