Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761Ab0AXWUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab0AXWUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509Ab0AXWUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:20:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45557 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab0AXWRp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:17:45 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "stephen hemminger" <shemminger@vyatta.com>,
       "Stephen Hemminger" <shemminger@vyatta.com>,
       "Tino Keitel" <tino.keitel@tikei.de>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
In-Reply-To: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hE3x9c-4KZM.A.I_E.6JMXLB@chimera>
Subject: [Bug #15133] Wake on LAN doesn't work in sky2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:04:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15133
Subject		: Wake on LAN doesn't work in sky2
Submitter	: Tino Keitel <tino.keitel@tikei.de>
Date		: 2010-01-15 9:10 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=166a0fd4c788ec7f10ca8194ec6d526afa12db75
References	: http://marc.info/?l=linux-kernel&m=126354704815848&w=4
Handled-By	: Stephen Hemminger <shemminger@vyatta.com>


