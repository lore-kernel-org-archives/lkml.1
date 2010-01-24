Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254Ab0AXWet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0AXWet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358Ab0AXWes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:34:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45731 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0AXWer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:34:47 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Eddy=20Petri=C8=99or?=" <eddy.petrisor+linbug@gmail.com>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.pWC.CcMXLB@chimera>
Subject: [Bug #14417] [Regression] Wireless driver iwlagn+iwlcore doesn't work after resume (needs reloading)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:22:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14417
Subject		: [Regression] Wireless driver iwlagn+iwlcore doesn't work after resume (needs reloading)
Submitter	: Eddy Petrișor <eddy.petrisor+linbug@gmail.com>
Date		: 2009-10-16 11:07 (101 days old)


