Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbYGMT1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbYGMT1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbYGMTSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:18:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39550 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbYGMTSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:18:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frans Pop" <elendil@planet.nl>
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
In-Reply-To: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <c6ZRbn0adb.A.7BB.DJleIB@albercik>
Subject: [Bug #10843] Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jul 2008 20:00:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10843
Subject		: Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-05-31 14:04 (44 days old)
References	: http://lkml.org/lkml/2008/6/7/206
		  http://lkml.org/lkml/2008/6/15/119
		  http://lkml.org/lkml/2008/6/23/160


