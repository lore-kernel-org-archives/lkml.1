Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbYEKVEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbYEKVEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbYEKVBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34105 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758983AbYEKVBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:25 -0400
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Neil Brown" <neilb@suse.de>,
       "Prakash Punnoor" <prakash@punnoor.de>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.Bu.tw1JIB@chimera>
Subject: [Bug #10621] WARNING: at include/linux/blkdev.h:443
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10621
Subject		: WARNING: at include/linux/blkdev.h:443
Submitter	: Prakash Punnoor <prakash@punnoor.de>
Date		: 2008-05-03 11:51 (9 days old)
References	: http://lkml.org/lkml/2008/5/3/43
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
		  Neil Brown <neilb@suse.de>


