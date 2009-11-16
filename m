Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZKPWzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZKPWzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbZKPWzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:55:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60296 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbZKPWy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:54:29 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.jSF.tSdALB@chimera>
Subject: [Bug #14630] sched_rt_periodic_timer vs cpu hotplug
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14630
Subject		: sched_rt_periodic_timer vs cpu hotplug
Submitter	: Heiko Carstens <heiko.carstens@de.ibm.com>
Date		: 2009-11-11 10:18 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=125793470309588&w=4
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://patchwork.kernel.org/patch/60250/


