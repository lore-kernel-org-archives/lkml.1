Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbYFVTOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbYFVTOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbYFVTFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:05:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389AbYFVTFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:05:16 -0400
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.jRD._spXIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4mRZUF-hVeG.A.MhE.xtpXIB@albercik>
Subject: [Bug #10918] 2.6.26-rc5: SLUB debug, lockdep warning...
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jun 2008 19:54:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10918
Subject		: 2.6.26-rc5: SLUB debug, lockdep warning...
Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
Date		: 2008-06-14 10:54 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121344091109597&w=4
Handled-By	: Vegard Nossum <vegard.nossum@gmail.com>
		  Daniel J Blueman <daniel.blueman@gmail.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10918#c2


