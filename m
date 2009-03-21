Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZCUTuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZCUTuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZCUTrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:47:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52135 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397AbZCUTrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:47:17 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jan Engelhardt" <jengelh@medozas.de>,
       "netdev" <netdev@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@vyatta.com>
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
In-Reply-To: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <fnEpM0mQZjO.A.o3E.S8TxJB@chimera>
Subject: [Bug #12868] iproute2 and regressing "ipv6: convert tunnels to net_device_ops"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 18:07:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12868
Subject		: iproute2 and regressing "ipv6: convert tunnels to net_device_ops"
Submitter	: Jan Engelhardt <jengelh@medozas.de>
Date		: 2009-03-09 14:46 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1326c3d5a4b792a2b15877feb7fb691f8945d203
References	: http://marc.info/?l=linux-netdev&m=123660999632730&w=4


