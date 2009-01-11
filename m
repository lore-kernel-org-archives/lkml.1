Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbZAKOHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbZAKOHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZAKN7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:59:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbZAKN7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:59:04 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Michael Roth" <mroth@nessie.de>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.qIB.VafaJB@chimera>
Subject: [Bug #12408] Funny problem with 2.6.28: Kernel stalls
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12408
Subject		: Funny problem with 2.6.28: Kernel stalls
Submitter	: Michael Roth <mroth@nessie.de>
Date		: 2008-12-25 15:14 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=123021931714282&w=4


