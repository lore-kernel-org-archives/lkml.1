Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbYGMTTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbYGMTTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbYGMTSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:18:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbYGMTSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:18:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
In-Reply-To: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <c6ZRbn0adb.A.R9.8IleIB@albercik>
Subject: [Bug #10862] forcedeth: lockdep warning on ethtool -s
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jul 2008 20:00:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10862
Subject		: forcedeth: lockdep warning on ethtool -s
Submitter	: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Date		: 2008-06-01 8:37 (43 days old)
References	: http://marc.info/?l=linux-kernel&m=121230964032247&w=4
Handled-By	: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Patch		: http://lkml.org/lkml/2008/6/15/120


