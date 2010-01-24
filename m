Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439Ab0AXWS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0AXWS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348Ab0AXWSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:18:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45583 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab0AXWSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:18:16 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Bruno=20Pr=C3=A9mont?=" <bonbons@linux-vserver.org>,
       "Eric Dumazet" <eric.dumazet@gmail.com>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
In-Reply-To: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hE3x9c-4KZM.A.W0E.4JMXLB@chimera>
Subject: [Bug #15137] NULL pointer dereference in vlan_skb_recv
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15137
Subject		: NULL pointer dereference in vlan_skb_recv
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2010-01-23 15:56 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=126426286507497&w=4
Handled-By	: Eric Dumazet <eric.dumazet@gmail.com>
Patch		: http://patchwork.kernel.org/patch/74999/
		  http://patchwork.kernel.org/patch/75002/


