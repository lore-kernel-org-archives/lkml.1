Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYH3VXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYH3VXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYH3VXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:23:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58077 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYH3VXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:23:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikhail Kshevetskiy" <mikhail.kshevetskiy@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.TJH.klbuIB@albercik>
Subject: [Bug #11191] 2.6.26-git8: spinlock lockup in c1e_idle()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:13 +0200 (CEST)
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
Date		: 2008-07-24 03:22 (38 days old)
References	: http://lkml.org/lkml/2008/7/23/317
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


