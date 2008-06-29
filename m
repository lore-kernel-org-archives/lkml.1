Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbYF2TjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbYF2TjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbYF2Tbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45685 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759561AbYF2Tb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:28 -0400
Cc: "Mike Travis" <travis@sgi.com>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.BDE.E79ZIB@albercik>
Subject: [Bug #10956] v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10956
Subject		: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-06-22 12:56 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121413950227884&w=4
Handled-By	: Rusty Russell <rusty@rustcorp.com.au>
		  Zhang, Yanmin <yanmin_zhang@linux.intel.com>
		  Mike Travis <travis@sgi.com>
Patch		: http://marc.info/?l=linux-kernel&m=121429495914484&w=4


