Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYKVWel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYKVWel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbYKVWaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:30:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37757 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974AbYKVW36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:29:58 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.ATC.i7HKJB@chimera>
Subject: [Bug #12031] DRM enabled kernel hangs hard on resume on x60
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12031
Subject		: DRM enabled kernel hangs hard on resume on x60
Submitter	: Jens Axboe <jens.axboe@oracle.com>
Date		: 2008-11-12 18:42 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=122651551216820&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


