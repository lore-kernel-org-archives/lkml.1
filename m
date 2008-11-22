Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYKVW3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYKVW3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYKVW2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:28:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37683 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbYKVW2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:28:46 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "David S. Miller" <davem@davemloft.net>,
       "James Cloos" <cloos@jhcloos.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.qBE.B9HKJB@chimera>
Subject: [Bug #11875] radeonfb lockup in .28-rc (bisected)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11875
Subject		: radeonfb lockup in .28-rc (bisected)
Submitter	: James Cloos <cloos@jhcloos.com>
Date		: 2008-10-28 0:00 (26 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1ee26bab14886350ba12a5c10cbc0696ac679bf
References	: http://marc.info/?l=linux-kernel&m=122515210200530&w=4
		  http://lkml.org/lkml/2008/11/10/12
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Patch		: http://lkml.org/lkml/2008/11/10/12


