Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbYHWT6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbYHWT6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbYHWTno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:43:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50243 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbYHWTnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:43:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Mikael Pettersson" <mikpe@it.uu.se>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <VSpL6AnBTS.A.zFG.3ZGsIB@albercik>
Subject: [Bug #11413] get_rtc_time() triggers NMI watchdog in hpet_rtc_interrupt()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 23 Aug 2008 20:10:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11413
Subject		: get_rtc_time() triggers NMI watchdog in hpet_rtc_interrupt()
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-08-23 9:48 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121948503224161&w=4
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&m=121950734922457&w=4


