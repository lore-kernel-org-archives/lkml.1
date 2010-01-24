Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765Ab0AXWod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0AXWod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645Ab0AXWfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:35:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45767 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab0AXWfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:35:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciek Sitarz" <macieks@freesco.pl>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.JGB.haMXLB@chimera>
Subject: [Bug #14748] e1000e NIC not working after reboot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:22:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14748
Subject		: e1000e NIC not working after reboot
Submitter	: Maciek Sitarz <macieks@freesco.pl>
Date		: 2009-12-06 13:04 (50 days old)


