Return-Path: <linux-kernel-owner+w=401wt.eu-S1764784AbYFGVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764784AbYFGVx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759123AbYFGVse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38970 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758240AbYFGVsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:30 -0400
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Ryan Hope" <rmh3093@gmail.com>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.LGE.q3vSIB@albercik>
Subject: [Bug #10760] PCIEHP breakage in 2.6.26-rc1,2.6.26-rc2,2.6.26-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10760
Subject		: PCIEHP breakage in 2.6.26-rc1,2.6.26-rc2,2.6.26-rc3
Submitter	: Ryan Hope <rmh3093@gmail.com>
Date		: 2008-05-19 17:47 (20 days old)
References	: http://marc.info/?l=linux-pci&amp;m=121121926401755&amp;w=2
Handled-By	: Matthew Wilcox <matthew@wil.cx>


