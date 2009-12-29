Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbZL2PhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbZL2PhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZL2PfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:35:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbZL2PfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:35:18 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andreas Friedrich" <andreas.friedrich@ts.fujitsu.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.WjB.MwhOLB@chimera>
Subject: [Bug #14902] Boot ends not on tty1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14902
Subject		: Boot ends not on tty1
Submitter	: Andreas Friedrich <andreas.friedrich@ts.fujitsu.com>
Date		: 2009-12-15 8:05 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=126086495304263&w=4


