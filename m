Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0BHAxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:53:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55507 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab0BHApS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:45:18 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
In-Reply-To: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iuJeop2ribM.A.2wB.ga1bLB@chimera>
Subject: [Bug #14657] perf subsystem breakage in 2.6.32-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  8 Feb 2010 01:28:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14657
Subject		: perf subsystem breakage in 2.6.32-rc7
Submitter	: Arjan van de Ven <arjan@infradead.org>
Date		: 2009-11-19 19:50 (81 days old)
References	: http://marc.info/?l=linux-kernel&m=125866013419738&w=4


