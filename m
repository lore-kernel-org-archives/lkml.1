Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbZIFU3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbZIFU3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbZIFU3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:29:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48813 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758585AbZIFU31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:29:27 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Am=C3=A9rico=20Wang?=" <xiyou.wangcong@gmail.com>,
       "Jens Axboe" <jens.axboe@oracle.com>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
In-Reply-To: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Vm51Upp4EV.A.SKC.HfBpKB@chimera>
Subject: [Bug #14133] WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 19:24:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14133
Subject		: WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule
Submitter	: Jens Axboe <jens.axboe@oracle.com>
Date		: 2009-08-31 20:43 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=125175143918050&w=4


