Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbYHBTaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbYHBTaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759083AbYHBT2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:28:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38036 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759287AbYHBT2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:28:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik>
In-Reply-To: <cbItfVMShGI.A.olC.UMLlIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5ZeQ4vXWqRC.A.NTE.bNLlIB@albercik>
Subject: [Bug #11201] kernel BUG at arch/x86/kernel/io_apic_64.c:357!
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  2 Aug 2008 20:04:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed
and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11201
Subject		: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
Submitter	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Date		: 2008-07-29 16:21 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121734804508255&w=4
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
		  Eric W. Biederman <ebiederm@xmission.com>
Patch		: http://marc.info/?l=linux-kernel&m=121735924628623&w=4


