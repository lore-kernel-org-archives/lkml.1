Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYGMT0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYGMT0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbYGMTSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:18:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbYGMTSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:18:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
In-Reply-To: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <c6ZRbn0adb.A.zd.EIleIB@albercik>
Subject: [Bug #10955] v2.6.26-rc7: BUG task_struct: Poison overwritten
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jul 2008 20:00:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10955
Subject		: v2.6.26-rc7: BUG task_struct: Poison overwritten
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-06-21 19:24 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=121407641925121&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


