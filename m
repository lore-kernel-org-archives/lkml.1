Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbYGFNHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbYGFNHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbYGFNBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:01:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54535 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757368AbYGFNBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "tosn00j02@sneakemail.com"@ogre.sisk.pl
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uBi7uNfg81L.A.a2D.U4LcIB@albercik>
Subject: [Bug #9791] Clock is running too fast^Wslow using acpi_pm clocksource
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Jul 2008 13:45:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Subject		: Clock is running too fast^Wslow using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-05-03 05:09 (65 days old)
Handled-By	: Maciej W. Rozycki <macro@linux-mips.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16180


