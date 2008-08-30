Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbYH3VhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbYH3VhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbYH3V0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:26:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58240 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758531AbYH3VZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:25:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "FUJITA Tomonori fujita.tomonori at lab.ntt.co.jp&gt;"@ogre.sisk.pl,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Laurent Pinchart" <laurentp@cse-semaphore.com>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.iOD.shbuIB@albercik>
Subject: [Bug #11462] v2.6.27-rc5 regression: mtd/block device issue with cmd_filter
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11462
Subject		: v2.6.27-rc5 regression: mtd/block device issue with cmd_filter
Submitter	: Laurent Pinchart <laurentp@cse-semaphore.com>
Date		: 2008-08-29 10:50 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=122000707631759&w=4
		  http://marc.info/?l=linux-kernel&m=122011643217462&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
		  FUJITA Tomonori fujita.tomonori at lab.ntt.co.jp&gt;
Patch		: http://lists.infradead.org/pipermail/linux-mtd/2008-August/022874.html


