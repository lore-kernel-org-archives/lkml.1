Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747Ab0AXWgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0AXWgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739Ab0AXWgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:36:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45830 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab0AXWgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:36:19 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "r4" <mk_4@centrum.cz>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.rp.uZMXLB@chimera>
Subject: [Bug #14895] BUG in kernel 2.6.32 when using luks encrypted root and RAID0..
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:23:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14895
Subject		: BUG in kernel 2.6.32 when using luks encrypted root and RAID0..
Submitter	: r4 <mk_4@centrum.cz>
Date		: 2009-12-03 18:24 (53 days old)
References	: http://marc.info/?l=linux-kernel&m=125986664904751&w=4


