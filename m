Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab0BHAug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:50:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55603 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab0BHAqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:46:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Dimitrios Apostolou" <jimis@gmx.net>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
In-Reply-To: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iuJeop2ribM.A.mH.lY1bLB@chimera>
Subject: [Bug #15040] High cpu temperature with 2.6.32 - bisected to cpuidle menu update
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  8 Feb 2010 01:28:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15040
Subject		: High cpu temperature with 2.6.32 - bisected to cpuidle menu update
Submitter	: Dimitrios Apostolou <jimis@gmx.net>
Date		: 2010-01-06 17:39 (33 days old)
References	: http://marc.info/?l=linux-kernel&m=126279952723036&w=4
Handled-By	: Arjan van de Ven <arjan@infradead.org>
Patch		: http://patchwork.kernel.org/patch/71962/


