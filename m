Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbZBXAZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbZBXAZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZBXAUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:20:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42544 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868AbZBXAUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:20:21 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Adam J. Richter" <adam@yggdrasil.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <peterz@infradead.org>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vP9hdyF4fL.A.ubD.7ozoJB@chimera>
Subject: [Bug #12760] 2.6.29-rc5 hanging at boot when CONFIG_LOCK_STAT=y
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 22:48:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12760
Subject		: 2.6.29-rc5 hanging at boot when CONFIG_LOCK_STAT=y
Submitter	: Adam J. Richter <adam@yggdrasil.com>
Date		: 2009-02-16 6:50 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=123476768023893&w=4
Handled-By	: Ingo Molnar <mingo@elte.hu>


