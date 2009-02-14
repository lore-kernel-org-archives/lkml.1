Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbZBNXWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbZBNXWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZBNXSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:18:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44819 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570AbZBNXSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:18:48 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Michal Suchanek" <hramrach@centrum.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
In-Reply-To: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ROx6X68CGJG.A.TTB.S50lJB@chimera>
Subject: [Bug #12393] debugging in dosemu causes lots of 'scheduling while atomic'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:50:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12393
Subject		: debugging in dosemu causes lots of 'scheduling while atomic'
Submitter	: Michal Suchanek <hramrach@centrum.cz>
Date		: 2009-01-09 07:28 (37 days old)
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		: http://lkml.org/lkml/2009/1/13/445


