Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbZDQAj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbZDQAj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759541AbZDQAeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:34:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36565 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759556AbZDQAeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:34:12 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.szH.Pw85JB@chimera>
Subject: [Bug #13113] tiobench read 50% regression with 2.6.30-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13113
Subject		: tiobench read 50% regression with 2.6.30-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-04-09 8:29 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=123926576802992&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
Patch		: http://marc.info/?l=linux-kernel&m=123971130800697&w=4


