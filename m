Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828Ab0AXWfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0AXWfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629Ab0AXWfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:35:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45769 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0AXWfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:35:36 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Lucas C. Villa Real" <lucasvr@gobolinux.org>,
       "reiserfs-devel@vger.kernel.org"@ogre.sisk.pl
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.tkB.JbMXLB@chimera>
Subject: [Bug #14656] Oops at __rmqueue+0x98 with 2.6.32-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:22:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14656
Subject		: Oops at __rmqueue+0x98 with 2.6.32-rc6
Submitter	: Lucas C. Villa Real <lucasvr@gobolinux.org>
Date		: 2009-11-19 3:48 (67 days old)
References	: http://marc.info/?l=linux-kernel&m=125860255229092&w=4


