Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219Ab0AXWgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0AXWgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679Ab0AXWfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:35:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45789 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab0AXWfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:35:38 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <akwatts@ymail.com>, "Arjan van de Ven" <arjan@infradead.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.DKB.paMXLB@chimera>
Subject: [Bug #14742] 2.6.32 new menu idle governor causes very high CPU temp
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:22:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14742
Subject		: 2.6.32 new menu idle governor causes very high CPU temp
Submitter	:  <akwatts@ymail.com>
Date		: 2009-12-05 17:24 (51 days old)


