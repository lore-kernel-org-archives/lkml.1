Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbZDFVv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbZDFVv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759605AbZDFVuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:50:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49856 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757718AbZDFVuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:50:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alessandro Bono" <alessandro.bono@gmail.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AsKNxFx2juN.A.yxB.tHn2JB@chimera>
Subject: [Bug #12670] BUG: unable to handle kernel paging request at pin_to_kill+0x21
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  6 Apr 2009 21:05:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12670
Subject		: BUG: unable to handle kernel paging request at pin_to_kill+0x21
Submitter	: Alessandro Bono <alessandro.bono@gmail.com>
Date		: 2009-02-08 11:04 (58 days old)
References	: http://marc.info/?l=linux-kernel&m=123409113223833&w=4


