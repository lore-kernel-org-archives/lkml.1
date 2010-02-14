Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0BOANa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:13:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60927 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab0BOANO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 19:13:14 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Dimitrios Apostolou" <jimis@gmx.net>
References: <fQEllunEdO.A.-LB.HyIeLB@chimera>
In-Reply-To: <fQEllunEdO.A.-LB.HyIeLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Xv2rBFCTXTH.A.VfC.1yIeLB@chimera>
Subject: [Bug #15040] High cpu temperature with 2.6.32 - bisected to cpuidle menu update
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Feb 2010 00:52:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15040
Subject		: High cpu temperature with 2.6.32 - bisected to cpuidle menu update
Submitter	: Dimitrios Apostolou <jimis@gmx.net>
Date		: 2010-01-06 17:39 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=126279952723036&w=4
Handled-By	: Arjan van de Ven <arjan@infradead.org>
Patch		: http://patchwork.kernel.org/patch/71962/


