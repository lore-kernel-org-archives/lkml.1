Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbYILUzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbYILUzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbYILUpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:45:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42864 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513AbYILUpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:45:36 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Gregory Haskins" <ghaskins@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Lin Ming" <ming.m.lin@intel.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.ZvG.OcsyIB@albercik>
Subject: [Bug #11505] oltp ~10% regression with 2.6.27-rc5 on stoakley machine
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11505
Subject		: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2008-09-04 7:06 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=122051202202373&w=4
		  http://marc.info/?t=122089704700005&r=1&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Gregory Haskins <ghaskins@novell.com>
		  Ingo Molnar <mingo@elte.hu>


