Return-Path: <linux-kernel-owner+w=401wt.eu-S1763949AbYFGVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763949AbYFGVu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758277AbYFGVsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956AbYFGVs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:26 -0400
Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.vyE.d4vSIB@albercik>
Subject: [Bug #10711] BUG: unable to handle kernel paging request - scsi_bus_uevent
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10711
Subject		: BUG: unable to handle kernel paging request - scsi_bus_uevent
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-14 11:23 (25 days old)
References	: http://lkml.org/lkml/2008/5/14/111


