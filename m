Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbZKPWxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbZKPWxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZKPWxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:53:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60254 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZKPWxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:53:48 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Miles Lane" <miles.lane@gmail.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.qrG.KTdALB@chimera>
Subject: [Bug #14485] System lockup running "cat /sys/kernel/debug/dri/0/i915_regs"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14485
Subject		: System lockup running "cat /sys/kernel/debug/dri/0/i915_regs"
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-26 4:00 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=125652968117713&w=4


