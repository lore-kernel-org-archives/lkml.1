Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbYF2Tgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbYF2Tgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759688AbYF2Tba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45681 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759277AbYF2Tb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:26 -0400
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.2oE.j79ZIB@albercik>
Subject: [Bug #10918] 2.6.26-rc5: SLUB debug, lockdep warning...
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:43 +0200 (CEST)
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
Date		: 2008-06-14 10:54 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=121344091109597&w=4
Handled-By	: Vegard Nossum <vegard.nossum@gmail.com>
		  Daniel J Blueman <daniel.blueman@gmail.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10918#c2


