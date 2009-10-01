Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZJAXSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZJAXSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZJAXI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:08:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57403 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbZJAXIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:08:53 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Am=C3=A9rico=20Wang?=" <xiyou.wangcong@gmail.com>,
       "Jens Axboe" <jens.axboe@oracle.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.oEC.lNTxKB@chimera>
Subject: [Bug #14133] WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:55:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14133
Subject		: WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule
Submitter	: Jens Axboe <jens.axboe@oracle.com>
Date		: 2009-08-31 20:43 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=125175143918050&w=4


