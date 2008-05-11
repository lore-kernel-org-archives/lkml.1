Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbYEKVOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbYEKVOB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759205AbYEKVBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34199 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759458AbYEKVBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:49 -0400
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>,
       =?utf-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
       "WANG Cong" <xiyou.wangcong@gmail.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.5QG.ev1JIB@chimera>
Subject: [Bug #10673] build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager: multiple definition of `phys_cpu_present_map'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10673
Subject		: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager: multiple definition of `phys_cpu_present_map'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-09 9:13 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121032450804476&amp;w=4
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
		  Ingo Molnar <mingo@elte.hu>
		  WANG Cong <xiyou.wangcong@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121042819904974&amp;w=4


