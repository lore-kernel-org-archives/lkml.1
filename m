Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYLGWs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYLGWs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbYLGWrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:47:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35147 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755649AbYLGWrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:47:14 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <SeAiKqCewiJ.A.VBH.CAFPJB@chimera>
In-Reply-To: <SeAiKqCewiJ.A.VBH.CAFPJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XUKIyYFWoBG.A.xxH.VAFPJB@chimera>
Subject: [Bug #11876] RCU hang on cpu re-hotplug with 2.6.27rc8
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Dec 2008 21:41:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11876
Subject		: RCU hang on cpu re-hotplug with 2.6.27rc8
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-10-06 23:28 (63 days old)
References	: http://marc.info/?l=linux-kernel&m=122333610602399&w=2
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


