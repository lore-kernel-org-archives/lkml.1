Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYKVWf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYKVWf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbYKVWaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:30:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37765 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756857AbYKVWaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:30:07 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Tino Keitel" <tino.keitel@gmx.de>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.nJC.c7HKJB@chimera>
Subject: [Bug #12038] Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12038
Subject		: Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2008-11-09 20:28 (14 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=66036f5862883fcc9f7ff8550685a5a3de1a57e4
References	: http://marc.info/?l=linux-kernel&m=122626258429689&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-kernel&m=122661443120581&w=4


