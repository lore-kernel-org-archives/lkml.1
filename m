Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYGMTYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYGMTYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbYGMTS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:18:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39567 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbYGMTSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:18:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Johannes Berg" <johannes@sipsolutions.net>
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
In-Reply-To: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <c6ZRbn0adb.A.XSH.AHleIB@albercik>
Subject: [Bug #11072] scsi-layer crash after usb storage device unplug
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jul 2008 20:00:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11072
Subject		: scsi-layer crash after usb storage device unplug
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2008-07-12 01:50 (2 days old)
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11072#c3


