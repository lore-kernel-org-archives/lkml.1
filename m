Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZL2Pdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZL2Pdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZL2Pde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:33:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbZL2Pdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:33:32 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Thomas Meyer" <thomas@m3y3r.de>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.2TD.WxhOLB@chimera>
Subject: [Bug #14670] i915: playing video via XVideo extension makes the screen flicker
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14670
Subject		: i915: playing video via XVideo extension makes the screen flicker
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2009-11-23 13:15 (37 days old)


