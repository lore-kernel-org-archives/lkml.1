Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYF2Tc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYF2Tc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbYF2TbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45661 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345AbYF2TbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:20 -0400
Cc: "James Bottomley" <James.Bottomley@HansenPartnership.com>,
       =?utf-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.U4F.Y99ZIB@albercik>
Subject: [Bug #10730] build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined reference to `request_firmware'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:42 +0200 (CEST)
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
Date		: 2008-05-16 17:06 (45 days old)
References	: http://marc.info/?l=linux-kernel&m=121095777616792&w=4
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
Patch		: http://marc.info/?l=linux-scsi&m=121101871800303&w=4


