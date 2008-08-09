Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYHJAKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYHJAKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYHJAJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:09:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47345 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbYHJAJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:09:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "David Brownell" <david-b@pacbell.net>, "Ingo Molnar" <mingo@elte.hu>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
In-Reply-To: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX_-nNkxKaF.A.QYD.wEjnIB@albercik>
Subject: [Bug #11190] [USB boot crash, -git] ecm_do_notify(), list_add corruption. prev-&gt;next should be next (ffff88003b8f82f8)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Aug 2008 00:43:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11190
Subject		: [USB boot crash, -git] ecm_do_notify(), list_add corruption. prev-&gt;next should be next (ffff88003b8f82f8)
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-07-22 13:40 (19 days old)
References	: http://marc.info/?l=linux-usb&m=121673409124827&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
		  David Brownell <david-b@pacbell.net>
Patch		: http://marc.info/?l=linux-kernel&m=121708481823201&w=4


