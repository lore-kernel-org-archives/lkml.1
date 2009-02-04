Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZBDMwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZBDMwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbZBDMtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:49:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44948 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbZBDMtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:49:04 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Mike Travis" <travis@sgi.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.tOH.wvYiJB@chimera>
Subject: [Bug #12495] thinkpad problems during resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:23:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12495
Subject		: thinkpad problems during resume
Submitter	: Christian Borntraeger <borntraeger@de.ibm.com>
Date		: 2009-01-17 15:48 (19 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e39ad415ac15116df213dfa2aa2a4f1b0857af9c
References	: http://marc.info/?l=linux-kernel&m=123220746125479&w=4
		  http://marc.info/?l=linux-kernel&m=123170361827197&w=4
Handled-By	: Mike Travis <travis@sgi.com>
Patch		: http://lkml.org/lkml/2009/1/16/375
		  http://lkml.org/lkml/2009/1/16/376
		  http://lkml.org/lkml/2009/1/16/378


