Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbZBDNAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbZBDNAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbZBDMu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:50:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45036 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438AbZBDMuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:50:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Petr Vandrovec" <vandrove@vc.cvut.cz>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.OKF.BvYiJB@chimera>
Subject: [Bug #12591] NULL pointer dereference in blk_queue_io_stat
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12591
Subject		: NULL pointer dereference in blk_queue_io_stat
Submitter	: Petr Vandrovec <vandrove@vc.cvut.cz>
Date		: 2009-01-31 23:58 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bc58ba9468d94d62c56ab9b47173583ec140b165
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


