Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbZCCWIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbZCCWIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758294AbZCCWAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:00:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39378 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244AbZCCWAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:00:35 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Sachin P. Sant" <sachinp@in.ibm.com>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.LxB.0UarJB@chimera>
Subject: [Bug #12792] 2.6.29-rc6-git4 boot failure
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12792
Subject		: 2.6.29-rc6-git4 boot failure
Submitter	: Sachin P. Sant <sachinp@in.ibm.com>
Date		: 2009-02-27 23:19 (5 days old)
References	: http://ozlabs.org/pipermail/linuxppc-dev/2009-February/068771.html


