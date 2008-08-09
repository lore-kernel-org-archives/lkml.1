Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYHJAYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYHJAYN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYHJALB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:11:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbYHJAKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:10:01 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Nishanth Aravamudan" <nacc@us.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Peter Zijlstra" <peterz@infradead.org>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
In-Reply-To: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX_-nNkxKaF.A.sNB.JDjnIB@albercik>
Subject: [Bug #11269] sched: revert cpu_clock to pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Aug 2008 00:43:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11269
Subject		: sched: revert cpu_clock to pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Submitter	: Nishanth Aravamudan <nacc@us.ibm.com>
Date		: 2008-08-04 19:46 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=121787924917646&w=4
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11269#c1


