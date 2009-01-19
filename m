Return-Path: <linux-kernel-owner+w=401wt.eu-S1762470AbZASX76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762470AbZASX76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760858AbZASXxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:53:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760684AbZASXxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:53:09 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christoph Hellwig" <hch@lst.de>, "Jens Axboe" <jens.axboe@oracle.com>,
       "Tejun Heo" <tj@kernel.org>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.3nG.d9QdJB@chimera>
Subject: [Bug #12497] new barrier warnings in 2.6.29-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:32:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12497
Subject		: new barrier warnings in 2.6.29-rc1
Submitter	: Christoph Hellwig <hch@lst.de>
Date		: 2009-01-12 15:46 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=123177528217154&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


