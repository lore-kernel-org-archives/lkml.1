Return-Path: <linux-kernel-owner+w=401wt.eu-S1762268AbZCCWSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762268AbZCCWSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760464AbZCCWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:15:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbZCCWPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:15:30 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Michael Roth" <mroth@nessie.de>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
In-Reply-To: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRIaSZpQ1ON.A.S9C.7darJB@chimera>
Subject: [Bug #12408] Funny problem with 2.6.28: Kernel stalls
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:41:32 +0100 (CET)
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
Date		: 2008-12-25 15:14 (69 days old)
References	: http://marc.info/?l=linux-kernel&m=123021931714282&w=4


