Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYFNVWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYFNVWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbYFNVTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:19:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50284 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbYFNVTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:19:50 -0400
Cc: "James Bottomley" <James.Bottomley@HansenPartnership.com>,
       =?utf-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.zDF.mKDVIB@albercik>
Subject: [Bug 10730] build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined reference to `request_firmware'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10730
Subject		: build issue #503 for v2.6.26-rc2-433-gf26a398 : undefined reference to `request_firmware'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-16 17:06 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=121095777616792&w=4
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
Patch		: http://marc.info/?l=linux-scsi&m=121101871800303&w=4


