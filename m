Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230Ab0AXWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0AXWjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809Ab0AXWi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:38:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab0AXWh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:37:27 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Marten Vance" <kernel@mv.so36.net>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.AmH.MZMXLB@chimera>
Subject: [Bug #15071] IBM/Lenovo Trackpoint speed, sensitivity reset after suspend if set via sysfs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:23:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15071
Subject		: IBM/Lenovo Trackpoint speed, sensitivity reset after suspend if set via sysfs
Submitter	: Marten Vance <kernel@mv.so36.net>
Date		: 2010-01-16 16:19 (9 days old)


