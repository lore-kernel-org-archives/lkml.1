Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197Ab0AJXJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0AJXJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154Ab0AJXJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:09:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab0AJXFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:05:18 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "=?utf-8?q?David=20H=C3=A4rdeman?=" <david@hardeman.nu>,
       "Len Brown" <lenb@kernel.org>,
       "=?utf-8?q?Malte=20Schr=C3=B6der?=" <maltesch@gmx.de>,
       "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CXIfLt-ygXM.A.eoC.-glSLB@chimera>
Subject: [Bug #14889] System wakeup by time not working anymore
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:56:17 +0100 (CET)
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
Date		: 2009-12-03 18:06 (39 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=abd6633c67925f90775bb74755f9c547e30f1f20
References	: http://marc.info/?l=linux-kernel&m=125986362631900&w=4
Handled-By	: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Patch		: http://patchwork.kernel.org/patch/70212/


