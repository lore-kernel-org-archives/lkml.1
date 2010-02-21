Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab0BUWGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:06:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59075 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab0BUWG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:06:29 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Jan Engelhardt" <jengelh@medozas.de>,
       "Jens Axboe" <jens.axboe@oracle.com>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
In-Reply-To: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wj3ZQZlk_KB.A.F_.0qagLB@chimera>
Subject: [Bug #15193] kswapd continuously active
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Feb 2010 22:42:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15193
Subject		: kswapd continuously active
Submitter	: Jan Engelhardt <jengelh@medozas.de>
Date		: 2010-01-22 23 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=126420434519039&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
		  Jens Axboe <jens.axboe@oracle.com>
Patch		: http://patchwork.kernel.org/patch/78856/


