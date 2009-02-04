Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbZBDM5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbZBDM5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756580AbZBDMuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:50:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45001 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbZBDMt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:49:59 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Riesen" <fork0@users.sf.net>, "Mike Travis" <travis@sgi.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.NpF.OvYiJB@chimera>
Subject: [Bug #12518] BUG: using smp_processor_id() in preemptible [00000000] code:  dellWirelessCtl/...
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12518
Subject		: BUG: using smp_processor_id() in preemptible [00000000] code:  dellWirelessCtl/...
Submitter	: Alex Riesen <fork0@users.sf.net>
Date		: 2009-01-21 14:21 (15 days old)


