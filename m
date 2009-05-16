Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbZEPWOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbZEPWOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZEPWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:13:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43840 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbZEPWNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:13:48 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Sukadev Bhattiprolu" <sukadev@linux.vnet.ibm.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.K7C._ZzDKB@chimera>
Subject: [Bug #13107] LTP 20080131 causes defunct processes w/2.6.30-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2009-04-09 15:43 (38 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
		  http://lkml.org/lkml/2009/4/10/193
Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>


