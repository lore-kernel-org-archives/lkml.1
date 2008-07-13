Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYGMTTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYGMTTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYGMTSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:18:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39544 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbYGMTR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:17:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Johannes Weiner" <hannes@saeurebad.de>
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
In-Reply-To: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <c6ZRbn0adb.A.jOB.KKleIB@albercik>
Subject: [Bug #10741] bug in `tty: BKL pushdown'?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jul 2008 20:00:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
Subject		: bug in `tty: BKL pushdown'?
Submitter	: Johannes Weiner <hannes@saeurebad.de>
Date		: 2008-05-18 2:16 (57 days old)
References	: http://marc.info/?l=linux-kernel&m=121107706506181&w=4
		  http://lkml.org/lkml/2008/6/16/104
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>


