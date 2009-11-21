Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZKUPHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZKUPHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbZKUPHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:07:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58632 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864AbZKUPHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:07:07 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>
References: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
In-Reply-To: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l2_yP_tdgYK.A.XGE.78_BLB@chimera>
Subject: [Bug #14298] warning at manage.c:361 (set_irq_wake), matrix-keypad related?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Nov 2009 15:51:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14298
Subject		: warning at manage.c:361 (set_irq_wake), matrix-keypad related?
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 20:07 (53 days old)
References	: http://marc.info/?l=linux-kernel&m=125434130703538&w=4


