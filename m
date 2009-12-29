Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZL2Pdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZL2Pdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZL2PdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:33:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbZL2PdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:33:19 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.UwD.jxhOLB@chimera>
Subject: [Bug #14630] sched_rt_periodic_timer vs cpu hotplug
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14630
Subject		: sched_rt_periodic_timer vs cpu hotplug
Submitter	: Heiko Carstens <heiko.carstens@de.ibm.com>
Date		: 2009-11-11 10:18 (49 days old)
References	: http://marc.info/?l=linux-kernel&m=125793470309588&w=4
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://patchwork.kernel.org/patch/60250/


