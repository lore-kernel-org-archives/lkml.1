Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZGGABd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZGGABd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbZGFX5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:57:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57901 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbZGFX5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:57:39 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Wu Fengguang" <fengguang.wu@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.lME.S0oUKB@chimera>
Subject: [Bug #13726] fio sync read 4k block size 35% regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:49:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13726
Subject		: fio sync read 4k block size 35% regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-07-01 11:25 (6 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=51daa88ebd8e0d437289f589af29d4b39379ea76
References	: http://lkml.org/lkml/2009/6/30/679
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>


