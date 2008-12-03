Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbYLDAGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbYLDAGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbYLDAC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:02:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48448 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503AbYLDACx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:02:53 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bfPM5B8Tx2B.A.iR.cpxNJB@chimera>
Subject: [Bug #12031] DRM enabled kernel hangs hard on resume (Intel graphics)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 22:58:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12031
Subject		: DRM enabled kernel hangs hard on resume (Intel graphics)
Submitter	: Jens Axboe <jens.axboe@oracle.com>
Date		: 2008-11-12 18:42 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=122651551216820&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=19007&action=view


