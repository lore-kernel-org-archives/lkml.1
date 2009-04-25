Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZDYW1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZDYW1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbZDYWUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:20:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41717 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609AbZDYWUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:20:06 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Steve Wise" <swise@opengridcomputing.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.3FC.rc48JB@chimera>
Subject: [Bug #13181] Crash in v2.6.30-rc3 (regression from 30-rc2)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:31:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13181
Subject		: Crash in v2.6.30-rc3 (regression from 30-rc2)
Submitter	: Gregory Haskins <ghaskins@novell.com>
Date		: 2009-04-23 2:29 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=124045383628477&w=4
		  http://marc.info/?l=linux-kernel&m=124033993702882&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


