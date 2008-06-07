Return-Path: <linux-kernel-owner+w=401wt.eu-S1763019AbYFGVvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763019AbYFGVvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbYFGVsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38945 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbYFGVs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:27 -0400
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.5uE.Z4vSIB@albercik>
Subject: [Bug #10714] Badness seen on 2.6.26-rc2 with lockdep enabled
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10714
Subject		: Badness seen on 2.6.26-rc2 with lockdep enabled
Submitter	: Balbir Singh <balbir@linux.vnet.ibm.com>
Date		: 2008-05-14 12:57 (25 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121076917429133&amp;w=4


