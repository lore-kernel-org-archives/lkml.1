Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbYKVWa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbYKVWa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbYKVW3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:29:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37702 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454AbYKVW3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:29:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pekka Paalanen" <pq@iki.fi>, "Steven Rostedt" <rostedt@goodmis.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.-hC.u7HKJB@chimera>
Subject: [Bug #11996] Tracing framework regression in 2.6.28-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11996
Subject		: Tracing framework regression in 2.6.28-rc3
Submitter	: Pekka Paalanen <pq@iki.fi>
Date		: 2008-11-09 10:13 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=122624392229317&w=4
Handled-By	: Steven Rostedt <rostedt@goodmis.org>


