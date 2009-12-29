Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbZL2Pe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbZL2Pe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZL2PeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:34:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39270 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbZL2PeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:34:11 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Stefan Zegenhagen" <sz@emlix.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.s1C.xwhOLB@chimera>
Subject: [Bug #14783] Unhandled IRQ on Thinkpad R61i: "irq 16: nobody cared"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14783
Subject		: Unhandled IRQ on Thinkpad R61i: "irq 16: nobody cared"
Submitter	: Stefan Zegenhagen <sz@emlix.com>
Date		: 2009-12-10 19:14 (20 days old)


