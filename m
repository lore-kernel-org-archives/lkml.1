Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbYILUsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbYILUsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbYILUoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:44:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173AbYILUoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:44:23 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.Bf.GesyIB@albercik>
Subject: [Bug #11336] 2.6.27-rc2:stall while mounting root fs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11336
Subject		: 2.6.27-rc2:stall while mounting root fs
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2008-08-12 12:37 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=121854484015909&w=4
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17622


