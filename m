Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbYHPUm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbYHPUm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYHPUdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:33:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37330 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbYHPUdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:33:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alok Kataria" <akataria@vmware.com>,
       "Alok N Kataria" <akataria@vmware.com>, "Dan Hecht" <dhecht@vmware.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Mikko Vinni" <mmvinni@yahoo.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A.v-E.dazpIB@albercik>
Subject: [Bug #11330] int3: 0000 in tsc_read_refs when using powernow_k7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2008 21:02:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11330
Subject		: int3: 0000 in tsc_read_refs when using powernow_k7
Submitter	: Mikko Vinni <mmvinni@yahoo.com>
Date		: 2008-08-14 04:21 (3 days old)
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11330#c2


