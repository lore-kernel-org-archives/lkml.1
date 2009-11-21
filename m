Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZKUPMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZKUPMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZKUPMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:12:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58663 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbZKUPHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:07:54 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
In-Reply-To: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l2_yP_tdgYK.A.fmD.K8_BLB@chimera>
Subject: [Bug #14384] tbench regression with 2.6.32-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Nov 2009 15:51:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14384
Subject		: tbench regression with 2.6.32-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-10-09 9:51 (44 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59abf02644c45f1591e1374ee7bb45dc757fcb88
References	: http://marc.info/?l=linux-kernel&m=125508216713138&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


