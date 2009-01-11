Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZAKOGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZAKOGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZAKN7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:59:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36882 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbZAKN7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:59:01 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christoph Hellwig" <hch@lst.de>, "Jens Axboe" <jens.axboe@oracle.com>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.2fB.bafaJB@chimera>
Subject: [Bug #12405] oops in __bounce_end_io_read under kvm
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12405
Subject		: oops in __bounce_end_io_read under kvm
Submitter	: Christoph Hellwig <hch@lst.de>
Date		: 2008-12-26 17:36 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=123031303400676&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


