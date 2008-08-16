Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYHPUbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYHPUbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYHPUbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:31:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37217 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbYHPUbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:31:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikhail Kshevetskiy" <mikhail.kshevetskiy@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A.ugH.CdzpIB@albercik>
Subject: [Bug #11191] 2.6.26-git8: spinlock lockup in c1e_idle()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2008 21:02:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11191
Subject		: 2.6.26-git8: spinlock lockup in c1e_idle()
Submitter	: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Date		: 2008-07-24 03:22 (24 days old)
References	: http://lkml.org/lkml/2008/7/23/317
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


