Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZEPWXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZEPWXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758043AbZEPWPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:15:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43892 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757994AbZEPWPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:15:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andy Fleming" <afleming@freescale.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Michael Guntsche" <mike@it-loops.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.F_.wYzDKB@chimera>
Subject: [Bug #13293] Kernel BUG under network load with gianfar
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13293
Subject		: Kernel BUG under network load with gianfar
Submitter	: Michael Guntsche <mike@it-loops.com>
Date		: 2009-05-03 13:36 (14 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0fd56bb5be6455d0d42241e65aed057244665e5e
References	: http://marc.info/?l=linux-kernel&m=124135824600924&w=4


