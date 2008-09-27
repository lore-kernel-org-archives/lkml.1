Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYI0Ru1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYI0Ru1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYI0Rk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:40:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39096 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYI0Rkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:40:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Tino Keitel" <tino.keitel@gmx.de>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
In-Reply-To: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <V8eU91268VO.A.wOG.L7m3IB@albercik>
Subject: =?utf-8?q?[Bug=20#11654]=20Devices=20enabled=20in=20/proc/acpi/wakeup=20do=20not=20wake=20up=20any=20more?=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 27 Sep 2008 17:56:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11654
Subject		: Devices enabled in /proc/acpi/wakeup do not wake up any more
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2008-09-22 20:29 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122211535021493&w=4
		  http://marc.info/?l=linux-kernel&m=122224359222164&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-kernel&m=122238185304167&w=4
		  http://marc.info/?l=linux-kernel&m=122237497811138&w=4


