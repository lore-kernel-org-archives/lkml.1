Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYI0RtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYI0RtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbYI0Rkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:40:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39096 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbYI0Rku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:40:50 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mark Lord" <lkml@rtr.ca>, "Mark Lord" <mlord@pobox.com>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
In-Reply-To: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <V8eU91268VO.A.2cG.Y7m3IB@albercik>
Subject: =?utf-8?q?[Bug=20#11629]=20quad=20G5=20fails=20to=20shut=20down?=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 27 Sep 2008 17:56:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11629
Subject		: quad G5 fails to shut down
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2008-09-23 14:20 (5 days old)
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11629#c8


