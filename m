Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZL2Pex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZL2Pex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZL2Pet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:34:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39306 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbZL2Pep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:34:45 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "=?utf-8?q?David=20H=C3=A4rdeman?=" <david@hardeman.nu>,
       "Len Brown" <lenb@kernel.org>,
       "=?utf-8?q?Malte=20Schr=C3=B6der?=" <maltesch@gmx.de>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.BaC.ZwhOLB@chimera>
Subject: [Bug #14889] System wakeup by time not working anymore
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14889
Subject		: System wakeup by time not working anymore
Submitter	: Malte Schröder <maltesch@gmx.de>
Date		: 2009-12-03 18:06 (27 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=abd6633c67925f90775bb74755f9c547e30f1f20
References	: http://marc.info/?l=linux-kernel&m=125986362631900&w=4


