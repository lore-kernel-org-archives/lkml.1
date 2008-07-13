Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYGMTYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYGMTYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbYGMTSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:18:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbYGMTSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:18:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Fitzgerald" <netzdamon@gmail.com>
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
In-Reply-To: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <c6ZRbn0adb.A.AZH.FHleIB@albercik>
Subject: [Bug #11065] WARNING: at drivers/ata/libata-sff.c:1321 ata_sff_hsm_move+0x8f/0x661()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jul 2008 20:00:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11065
Subject		: WARNING: at drivers/ata/libata-sff.c:1321 ata_sff_hsm_move+0x8f/0x661()
Submitter	: Greg Fitzgerald <netzdamon@gmail.com>
Date		: 2008-07-09 19:36 (5 days old)


