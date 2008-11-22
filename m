Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbYKVWgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbYKVWgr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYKVWaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:30:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37779 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974AbYKVWaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:30:11 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jesper Dangaard Brouer" <hawk@diku.dk>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.BoB.H7HKJB@chimera>
Subject: [Bug #12082] IRQ and MSI allocations broken without sparse irq
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12082
Subject		: IRQ and MSI allocations broken without sparse irq
Submitter	: Jesper Dangaard Brouer <hawk@diku.dk>
Date		: 2008-11-20 19:48 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122721060501073&w=4
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		: http://marc.info/?l=linux-kernel&m=122722773824802&w=4


